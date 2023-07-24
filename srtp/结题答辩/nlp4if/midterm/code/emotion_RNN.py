from mxnet import gluon, init, nd
from mxnet.contrib import text
from mxnet.gluon import data as gdata, loss as gloss, nn, rnn, utils as gutils
import process

lang = 'english'
net_type = 'RNN'
ques_idx = 'q1'

# 读取和预处理训练数据集
batch_size = 64
train_data = process.read_file(lang, 'train', ques_idx)
test_data = process.read_file(lang, 'test')
vocab = process.get_vocab(train_data)
#features, labels = process.preprocess(train_data, vocab)
train_iter = gdata.DataLoader(gdata.ArrayDataset(
    *process.preprocess(train_data, vocab)), batch_size, shuffle=True)
# only can use vocab obtained from train set
test_iter = gdata.DataLoader(gdata.ArrayDataset(
    *process.preprocess(test_data, vocab)), batch_size, shuffle=False)

# 使用循环神经网络模型
class BiRNN(nn.Block):
    def __init__(self, vocab, embed_size, num_hiddens, num_layers, **kwargs):
        super(BiRNN, self).__init__(**kwargs)
        self.embedding = nn.Embedding(len(vocab), embed_size)
        # bidirectional设为True即得到双向循环神经网络
        self.encoder = rnn.LSTM(num_hiddens, num_layers=num_layers,
                                bidirectional=True, input_size=embed_size)
        self.decoder = nn.Dense(2)

    def forward(self, inputs):
        # inputs的形状是(批量大小, 词数)，因为LSTM需要将序列作为第一维，所以将输入转置后
        # 再提取词特征，输出形状为(词数, 批量大小, 词向量维度)
        embeddings = self.embedding(inputs.T)
        # rnn.LSTM只传入输入embeddings，因此只返回最后一层的隐藏层在各时间步的隐藏状态。
        # outputs形状是(词数, 批量大小, 2 * 隐藏单元个数)
        outputs = self.encoder(embeddings)
        # 连结初始时间步和最终时间步的隐藏状态作为全连接层输入。它的形状为
        # (批量大小, 4 * 隐藏单元个数)。
        encoding = nd.concat(outputs[0], outputs[-1])
        outs = self.decoder(encoding)
        return outs

## 创建包含2个隐藏层的双向循环神经网络
embed_size, num_hiddens, num_layers, ctx = 100, 100, 2, process.try_all_gpus()
net = BiRNN(vocab, embed_size, num_hiddens, num_layers)
net.initialize(init.Xavier(), ctx=ctx)


## 加载预训练的词向量
glove_embedding = text.embedding.create(
    'glove', pretrained_file_name='glove.6B.100d.txt', vocabulary=vocab)

net.embedding.weight.set_data(glove_embedding.idx_to_vec)
net.embedding.collect_params().setattr('grad_req', 'null')


## 训练模型
lr, num_epochs = 0.01, 1
trainer = gluon.Trainer(net.collect_params(), 'adam', {'learning_rate': lr})
loss = gloss.SoftmaxCrossEntropyLoss()
process.train(train_iter, net, loss, trainer, ctx, num_epochs)

# 生成预测结果
process.test(test_iter, net, ctx, lang, net_type, num_epochs, ques_idx)