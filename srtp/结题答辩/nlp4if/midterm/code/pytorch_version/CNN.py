import os
import torch
from torch import nn
import torchtext.vocab as Vocab
import torch.utils.data as gdata
import  torch.nn.functional as F
import process_torch

os.environ["CUDA_VISIBLE_DEVICES"] = "0"
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

lang = 'english'
net_type = 'CNN'
#ques_idx = 'q2'

# # 一维神经网络
# def corr1d(X, K):
#     w = K.shape[0]
#     Y = nd.zeros((X.shape[0] - w + 1))
#     for i in range(Y.shape[0]):
#         Y[i] = (X[i: i + w] * K).sum()
#     return Y

# X, K = nd.array([0, 1, 2, 3, 4, 5, 6]), nd.array([1, 2])
# corr1d(X, K)

# def corr1d_multi_in(X, K):
#     # 首先沿着X和K的第0维（通道维）遍历。然后使用*将结果列表变成add_n函数的位置参数
#     #（positional argument）来进行相加
#     return nd.add_n(*[corr1d(x, k) for x, k in zip(X, K)])

# X = nd.array([[0, 1, 2, 3, 4, 5, 6],
#               [1, 2, 3, 4, 5, 6, 7],
#               [2, 3, 4, 5, 6, 7, 8]])
# K = nd.array([[1, 2], [3, 4], [-1, -3]])
# corr1d_multi_in(X, K)


class GlobalMaxPool1d(nn.Module):
    def __init__(self):
        super(GlobalMaxPool1d, self).__init__()
    def forward(self, x):
         # x shape: (batch_size, channel, seq_len)
        return F.max_pool1d(x, kernel_size=x.shape[2]) # shape: (batch_size, channel, 1)

# textCNN模型
class TextCNN(nn.Module):
    def __init__(self, vocab, embed_size, kernel_sizes, num_channels):
        super(TextCNN, self).__init__()
        self.embedding = nn.Embedding(len(vocab), embed_size)
        # 不参与训练的嵌入层
        self.constant_embedding = nn.Embedding(len(vocab), embed_size)
        self.dropout = nn.Dropout(0.5)
        self.decoder = nn.Linear(sum(num_channels), 2)
        # 时序最大池化层没有权重，所以可以共用一个实例
        self.pool = GlobalMaxPool1d()
        self.convs = nn.ModuleList()  # 创建多个一维卷积层
        for c, k in zip(num_channels, kernel_sizes):
            self.convs.append(nn.Conv1d(in_channels = 2*embed_size, 
                                        out_channels = c, 
                                        kernel_size = k))

    def forward(self, inputs):
        # 将两个形状是(批量大小, 词数, 词向量维度)的嵌入层的输出按词向量连结
        embeddings = torch.cat((
            self.embedding(inputs), 
            self.constant_embedding(inputs)), dim=2) # (batch, seq_len, 2*embed_size)
        # 根据Conv1D要求的输入格式，将词向量维，即一维卷积层的通道维(即词向量那一维)，变换到前一维
        embeddings = embeddings.permute(0, 2, 1)
        # 对于每个一维卷积层，在时序最大池化后会得到一个形状为(批量大小, 通道大小, 1)的
        # Tensor。使用flatten函数去掉最后一维，然后在通道维上连结
        encoding = torch.cat([self.pool(F.relu(conv(embeddings))).squeeze(-1) for conv in self.convs], dim=1)
        # 应用丢弃法后使用全连接层得到输出
        outputs = self.decoder(self.dropout(encoding))
        return outputs



def pred_a_task(ques_idx):
    # 读取和预处理训练数据集
    batch_size = 64
    train_data = process_torch.read_file(lang, 'train', ques_idx)
    test_data = process_torch.read_file(lang, 'test')
    vocab = process_torch.get_vocab(train_data)
    #features, labels = process_torch.preprocess(train_data, vocab)
    train_iter = gdata.DataLoader(gdata.ArrayDataset(
        *process_torch.preprocess(train_data, vocab)), batch_size, shuffle=True)
    # only can use vocab obtained from train set
    test_iter = gdata.DataLoader(gdata.ArrayDataset(
        *process_torch.preprocess(test_data, vocab)), batch_size, shuffle=False)

    # 创建一个textCNN实例
    embed_size, kernel_sizes, nums_channels = 100, [3, 4, 5], [100, 100, 100]
    net = TextCNN(vocab, embed_size, kernel_sizes, nums_channels)

    # TODO:加载预训练的词向量
    glove_vocab = Vocab.GloVe(name='6B', dim=100, cache="glove")
    net.embedding.weight.data.copy_(
		d2l.load_pretrained_embedding(vocab.itos, glove_vocab))
    net.constant_embedding.weight.data.copy_(
		d2l.load_pretrained_embedding(vocab.itos, glove_vocab))
    net.constant_embedding.weight.requires_grad = False

    # 训练模型
    lr, num_epochs = 0.001, 1
    optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, net.parameters()), lr=lr)
    loss = nn.CrossEntropyLoss()
    process_torch.train(train_iter, net, loss, optimizer, device, num_epochs)

    # 生成预测结果
    process_torch.test(test_iter, net, device, lang, net_type, num_epochs, ques_idx)


def pred_all_tasks():
    for ques_idx in ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7']:
        pred_a_task(ques_idx)

pred_all_tasks()