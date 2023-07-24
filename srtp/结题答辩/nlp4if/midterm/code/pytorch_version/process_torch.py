import collections
import os
import random
import time
import pandas
import mxnet as mx

from mxnet.contrib.text import vocab
from mxnet.contrib import text
from mxnet import nd
from mxnet import autograd
from mxnet.gluon import utils as gutils

def read_file(lang='english', type='train', ques_idx='q1'):
	"""Reading the input train set for analysis..."""
	data = []
	input_files = []
	if type == 'test':
		file='covid19_disinfo_binary_'+lang+'_'+'test_input.tsv'
		input_files.append('test-input')
	else:
		file='covid19_disinfo_binary_'+lang+'_'+type+'.tsv'
		input_files.append('v1')
		if lang != 'bulgarian':
			input_files.append('v3')
	for folder in input_files:
		file_name = os.path.join('data/', lang, folder, file)
		tweetDict = pandas.read_csv(file_name, delimiter='\t', header=0, encoding='utf-8')	
		for i in range(len(tweetDict)):
			if tweetDict.__contains__(ques_idx + '_label'):
				if tweetDict[ques_idx + '_label'][i] != 'nan':
					label_value = 1 if tweetDict[ques_idx + '_label'][i] == 'yes' else 0
					data.append([tweetDict['tweet_text'][i].replace('\n', ''), label_value])
			else:
				data.append([tweetDict['text'][i].replace('\n', ''), 0])
	if type == 'train':
		random.shuffle(data)
	return data


def get_tokenized(data):
	"""Get the tokenized train data set for analysis..."""
	def tokenizer(text):
		return [token.lower() for token in text.split(' ')]
	
	return [tokenizer(tweet_text) for tweet_text, q in data]


def get_vocab(data):
	"""Get the vocabulary for the train set for analysis..."""
	tokenized_data = get_tokenized(data)
	counter = collections.Counter([token for tweet_text in tokenized_data for token in tweet_text])
	return text.vocab.Vocabulary(counter, min_freq=5)


def preprocess(data, vocab):
	"""Preprocess the train set for analysis..."""
	max_len = 500

	# pad those string with less than 500 words; cut those too long strings
	def pad(x):
		return x[0:max_len] if len(x) > max_len else x + [0] * (max_len - len(x))

	tokenized_data = get_tokenized(data)
	features = nd.array([pad(vocab.to_indices(x)) for x in tokenized_data])
	labels = nd.array([q for tweet_text, q in data])

	return features, labels

# train_data = read_file('english', 'train')
# test_data = read_file('english', 'test')
# vocab = get_vocab(train_data)
# features, labels = preprocess(train_data, vocab)
# batch_size = 64


# train_iter = gdata.DataLoader(gdata.ArrayDataset(
#     *preprocess(train_data, vocab)), batch_size, shuffle=True)
# # only can use vocab obtained from train set
# test_iter = gdata.DataLoader(gdata.ArrayDataset(
#     *preprocess(test_data, vocab)), batch_size, shuffle=False)


def try_all_gpus():
    """Return all available GPUs, or [mx.cpu()] if there is no GPU."""
    ctxes = []
    try:
        for i in range(16):
            ctx = mx.gpu(i)
            _ = nd.array([0], ctx=ctx)
            ctxes.append(ctx)
    except mx.base.MXNetError:
        pass
    if not ctxes:
        ctxes = [mx.cpu()]
    return ctxes



def _get_batch(batch, ctx):
    """Return features and labels on ctx."""
    features, labels = batch
    if labels.dtype != features.dtype:
        labels = labels.astype(features.dtype)
    return (gutils.split_and_load(features, ctx),
            gutils.split_and_load(labels, ctx), features.shape[0])




def train(train_iter, net, loss, trainer, ctx, num_epochs):
    """Train and evaluate a model."""
    print('training on', ctx)
    if isinstance(ctx, mx.Context):
        ctx = [ctx]
    for epoch in range(num_epochs):
        train_l_sum, train_acc_sum, n, m, start = 0.0, 0.0, 0, 0, time.time()
        for i, batch in enumerate(train_iter):
            Xs, ys, batch_size = _get_batch(batch, ctx)
            ls = []
            with autograd.record():
                y_hats = [net(X) for X in Xs]
                ls = [loss(y_hat, y) for y_hat, y in zip(y_hats, ys)]
            for l in ls:
                l.backward()

            # print('ys = ')
            # print(ys)


            # print('y_hats = ')
            # print(y_hats)

            # print('y_har.argmax(axis=1): ')
            # print([y_hat.argmax(axis=1) for y_hat in y_hats])

            trainer.step(batch_size)
            train_l_sum += sum([l.sum().asscalar() for l in ls])
            n += sum([l.size for l in ls])
            train_acc_sum += sum([(y_hat.argmax(axis=1) == y).sum().asscalar()
                                 for y_hat, y in zip(y_hats, ys)])
            m += sum([y.size for y in ys])


            #break


        # run test tweet_text and generate prediction results
        print('epoch %d, loss %.4f, train acc %.3f, time %.1f sec'
              % (epoch + 1, train_l_sum / n, train_acc_sum / m,
               time.time() - start))

# ctx = [mx.cpu()]
# num_epochs = 5


# write a column
def write_res(fp, pred_list, ques_idx):
	fp.seek(0, 0)
	prev_res = fp.readlines()
	fp.seek(0, 0)
	if len(prev_res) == 0:
		for pred_val in pred_list:
			fp.write(pred_val + '\n')
	else:
		for prev_row, pred_val in zip(prev_res, pred_list):
			col1 = 'yes'
			if ques_idx in ['q2', 'q3', 'q4', 'q5']:
				col1 = (prev_row.split('\t'))[0]
			print(col1)
			final_res = pred_val if col1 == 'yes' else 'nan'
			print(final_res)
			write_cont = prev_row.replace('\n','\t') + final_res + '\n'
			fp.write(write_cont)

# fp = open('res/testForm.txt', 'a+')
# fp.close()
# for i in range(7):
# 	with open('res/testForm.txt', 'r+')as f:
# 		list = []
# 		if i == 0 or i == 5 or i == 6:
# 			list = ['no'] * 100
# 		else:
# 			list = ['nan'] * 100
# 		write_res(f, list, 'q' + str(i))


def test(test_iter, net, ctx, lang='english', net_type='CNN', epoch_num=5, ques_idx='q1'):
	print('start generating test prediction...')
	if isinstance(ctx, mx.Context):
		ctx = [ctx]
	file_name = 'res/' + lang + '/' + net_type + '/tot_epoch=' + str(epoch_num) + '.txt';
	# create the file if not exists
	fp = open(file_name, 'a+')
	fp.close()
	# write prediction
	with open(file_name, 'r+') as f:
		pred_list = []
		for batch in test_iter:
			features, labels, size = _get_batch(batch, ctx)
			preds = [net(X).argmax(axis=1) for X in features]
			#print(preds)
			#print('---------------')
			for pred_row in preds:
				for pred in pred_row:
					#print(pred.asscalar())
					pred_list.append('yes' if pred.asscalar() == 1.0 else 'no' if pred.asscalar() == 0.0 else 'nan')
		write_res(f, pred_list, ques_idx)
	print('generate test prediction successfully')