import torch
import torchvision
import torchvision.transforms as transforms

import mxnet as mx
# a = mx.nd.ones((2, 3), mx.gpu())
# b = a * 2 + 1
# b.asnumpy()
# print(mx.__version__)

import torch
print(torch.version.cuda)



if torch.cuda.is_available():
    print("Yes")
else:
    print("no")
