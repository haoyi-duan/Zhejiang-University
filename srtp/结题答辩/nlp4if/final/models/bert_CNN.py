from numpy import pad
import torch.nn as nn
import transformers
from transformers import AutoModel, BertModel,  BertTokenizerFast
import torch

class LinearBlock(nn.Module):
    def __init__(self, in_dim, out_dim, use_bn=True):
        super(LinearBlock, self).__init__()

        self.linear = nn.Linear(in_dim, out_dim)
        self.use_bn = use_bn
        self.bn = nn.BatchNorm1d(out_dim)
        self.relu = nn.ReLU()

    def forward(self, x):
        if self.use_bn:
          return self.relu(self.bn(self.linear(x)))
        else:
          return self.relu(self.linear(x))

class BERTCNN(nn.Module):
    def __init__(self, freeze_bert_params=True, dropout_prob=0.1, base='bert-base-uncased'):
      super(BERTCNN, self).__init__()
      print("BertCNN Being Used!!!\n\n\n")
      self.embeddings = AutoModel.from_pretrained(base)#, output_hidden_states = True)

      if freeze_bert_params:
        for param in self.embeddings.parameters():
          param.requires_grad=False

      self.dropout_common = nn.Dropout(dropout_prob)

      embedding_dim=128*3

      self.conv3 = nn.Sequential(
		  nn.Conv2d(in_channels=1, out_channels=128, kernel_size=(3, 56), padding=1),
		  nn.ReLU(),
		  nn.MaxPool2d(kernel_size=(56-3+1, 1))
	  )  
      self.conv4 = nn.Sequential(
		  nn.Conv2d(in_channels=1, out_channels=128, kernel_size=(4, 56), padding=1),
		  nn.ReLU(),
		  nn.MaxPool2d(kernel_size=(56-4+1, 1))
	  )
      self.conv5 = nn.Sequential(
		  nn.Conv2d(in_channels=1, out_channels=128, kernel_size=(5, 56), padding=1),
		  nn.ReLU(),
		  nn.MaxPool2d(kernel_size=(56-5+1, 1))
	  )

      self.fc1 = LinearBlock(embedding_dim,128*3)
      self.fc2 = LinearBlock(128*3,128*3)

      # softmax activation functions
      self.out_shared = LinearBlock(128*3, 192)
      self.out1 = nn.Linear(192, 2  )
      self.out2 = nn.Linear(192, 3)
      self.out3 = nn.Linear(192, 3)
      self.out4 = nn.Linear(192, 3)
      self.out5 = nn.Linear(192, 3)
      self.out6 = nn.Linear(384, 2)
      self.out7 = nn.Linear(384, 2)

    #define the forward pass
    def forward(self, sent_id, mask):
      # Bert
      sequence_output = self.embeddings(sent_id, attention_mask=mask)[0]
      #print("Sequence Output Shape : {}".format(sequence_output.shape))

      x_3 = self.conv3(torch.unsqueeze(sequence_output, 1))
      x_4 = self.conv4(torch.unsqueeze(sequence_output, 1))
      x_5 = self.conv5(torch.unsqueeze(sequence_output, 1))

      x_3 = torch.mean(x_3, (2, 3)) # (32, 128)
      x_4 = torch.mean(x_4, (2, 3)) # (32, 128)
      x_5 = torch.mean(x_5, (2, 3)) # (32, 128)

      # x (32, 768)
      x = torch.cat((x_3, x_4, x_5), 1)

      # Initial layers
      x = self.fc1(x)
      x = self.dropout_common(x)
      x = self.fc2(x)

      # Share out1 to out5 with initial weights since output depends on output of out1
      shared_x = self.out_shared(x)
      out1 = self.out1(shared_x)
      out2 = self.out2(shared_x)
      out3 = self.out3(shared_x)
      out4 = self.out4(shared_x)
      out5 = self.out5(shared_x)
      out6 = self.out6(x)
      out7 = self.out7(x)

      return [out1, out2, out3, out4, out5, out6, out7]