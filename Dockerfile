From nvidia/cuda:9.0-cudnn7-runtime
LABEL maintainer "exam@exam.jp"
RUN apt-get update
RUN apt-get install -y curl git unzip imagemagick bzip2
RUN git clone git://github.com/yyuu/pyenv.git .pyenv

WORKDIR /
ENV HOME  /
ENV PYENV_ROOT /.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install anaconda3-4.4.0
RUN pyenv global anaconda3-4.4.0
RUN pyenv rehash

RUN pip install opencv-python tqdm h5py keras tensorflow-gpu kaggle-cli gym
RUN pip install chainer
RUN pip install http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp36-cp36m-manylinux1_x86_64.whl 
RUN pip install torchvision
