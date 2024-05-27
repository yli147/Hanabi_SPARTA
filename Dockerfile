FROM nvidia/cuda:11.6.1-devel-ubuntu20.04
EXPOSE 3000 8080 5000

ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get -y install build-essential
RUN apt-get install -y unzip
RUN apt-get install -y wget
RUN apt-get install -y vim
# RUN add-apt-repository ppa:mhier/libboost-latest
RUN apt update
RUN apt install -y libboost-all-dev

RUN apt-get update
RUN apt-get install -y python3-pip
RUN apt-get -y install python3-setuptools

ENV HTTP_PROXY child-prc.intel.com:913
ENV HTTPS_PROXY child-prc.intel.com:913
RUN export http_proxy=$HTTP_PROXY
RUN export https_proxy=$HTTPS_PROXY

WORKDIR /
RUN wget -e use_proxy=yes -e https_proxy=child-prc.intel.com:913 "https://download.pytorch.org/libtorch/cu116/libtorch-shared-with-deps-1.13.1%2Bcu116.zip"
RUN unzip libtorch-shared-with-deps-1.13.1+cu116.zip

RUN pip3 install torch==1.4.0
RUN apt-get install -y zlib1g-dev
RUN pip3 install quart

COPY . /home/game
WORKDIR /home/game

ENV SEARCH_THRESH 0.1
ENV SEARCH_BASELINE 1
ENV PARTNER_UNC 0.2
ENV SEARCH_N 10000
ENV NUM_THREADS 1000
ENV BPBOT TorchBot
ENV TORCHBOT_MODEL best_lstm2.pth
RUN pip3 install -U numpy

RUN INSTALL_TORCHBOT=1 python3 setup.py install

ENV BOT TorchBot
CMD [ "sh", "-c", "python3 -u webapp/server.py" ]
