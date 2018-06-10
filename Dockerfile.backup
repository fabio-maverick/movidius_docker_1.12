FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
MAINTAINER Fábio Magalhães <fabio.magalhaes@gmail.com>

ENV PYTHONPATH /opt/movidius/mvnc/python:${PYTHONPATH}
ARG TF_VERSION

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y wget
RUN apt-get install -y sudo
RUN apt-get install -y vim
RUN apt-get install -y lsb-release
RUN apt-get install -y python3-pip

RUN git clone https://github.com/movidius/ncsdk.git /ncsdk
RUN git clone https://github.com/movidius/ncappzoo.git /ncappzoo

RUN pip install --upgrade pip
RUN pip install tensorflow-gpu==1.4.1
RUN pip3 install --upgrade pip

# RUN pip3 install opencv-python
# RUN pip3 install opencv-contrib-python

# Install OpenCV from source
RUN echo "";
RUN echo "Installing OpenCV";
RUN echo "";

RUN sudo apt-get update -y && sudo apt-get upgrade -y
RUN sudo apt-get install -y build-essential cmake pkg-config
RUN sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
RUN sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN sudo apt-get install -y libxvidcore-dev libx264-dev
RUN sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
RUN sudo apt-get install -y libatlas-base-dev gfortran
RUN sudo apt-get install -y python2.7-dev python3-dev

RUN cd ~
RUN wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.0.zip
RUN sudo apt-get install zip unzip
RUN unzip opencv.zip
RUN wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.0.zip
RUN unzip opencv_contrib.zip
RUN cd /opencv-3.3.0/ \
    && mkdir build && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_CUDA=OFF                     \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D WITH_V4L=ON \
      -D BUILD_opencv_cnn_3dobj=OFF \
      -D BUILD_opencv_dnn_modern=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.3.0/modules \
      -D BUILD_EXAMPLES=OFF .. \
&& make -j `nproc` \
&& sudo make install \
&& sudo ldconfig \
&& cd ~ \
&& sudo rm -rf ./opencv-3.3.0/ \
&& sudo rm -rf ./opencv_contrib-3.3.0/

RUN echo "";
RUN echo "OpenCV Installation Completed!";
RUN echo "";

WORKDIR /ncsdk
RUN make install
#RUN make examples

# Go to NCSDK root
WORKDIR /
RUN git clone https://github.com/tensorflow/tensorflow.git tf-${TF_VERSION}
RUN git clone https://github.com/tensorflow/models.git tf-models
RUN cd tf-${TF_VERSION} && git checkout ${TF_VERSION} && cd ..
ENV TF_SRC_PATH=/tf-${TF_VERSION}
ENV TF_MODELS_PATH=/tf-models

# we only check with tensorflow example
WORKDIR /ncappzoo/tensorflow
#RUN make

CMD ["bash"]
