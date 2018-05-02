# Download the base image ubuntu with cuda8 and cudnn5
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu14.04

MAINTAINER Gayathri Mahalingam (mahalingamg@uncw.edu)

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y \
        python-scipy \
        libprotobuf-dev \
        libleveldb-dev \
        libsnappy-dev \
        protobuf-compiler \
        libatlas-base-dev \
        libopencv-dev \
        libxml2-dev \
        libxslt-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        liblmdb-dev \
        bc \
		build-essential \
		cmake \
		curl \
		g++ \
		gfortran \
		git \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libopenjpeg2 \
		libpng12-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
		nano \
		pkg-config \
		python-dev \
		software-properties-common \
		unzip \
		vim \
		wget \
		zlib1g-dev \
		qt5-default \
		libvtk6-dev \
		zlib1g-dev \
		libjpeg-dev \
		libwebp-dev \
		libpng-dev \
		libtiff5-dev \
		libjasper-dev \
		libopenexr-dev \
		libgdal-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libtheora-dev \
		libvorbis-dev \
		libxvidcore-dev \
		libx264-dev \
		yasm \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libv4l-dev \
		libxine2-dev \
		libtbb-dev \
		libeigen3-dev \
		python-dev \
		python-tk \
		python-numpy \
		python3-dev \
		python3-tk \
		python3-numpy \
		ant \
		default-jdk \
		doxygen \
		&& \
	    apt-get clean && \
	    apt-get autoremove && \
	    rm -rf /var/lib/apt/lists/* && \
        update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3

# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
	python get-pip.py && \
	rm get-pip.py

# Install useful Python packages using apt-get to avoid version incompatibilities with Tensorflow binary
# especially numpy, scipy, skimage and sklearn (see https://github.com/tensorflow/tensorflow/issues/2034)
RUN apt-get update && apt-get install -y \
		python-numpy \
		python-scipy \
		python-nose \
		python-h5py \
		python-skimage \
		python-matplotlib \
		python-pandas \
		python-sklearn \
		python-sympy \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --no-install-recommends libboost-all-dev

# create a dir for all code
RUN mkdir /code

RUN cd /code && git clone https://github.com/gayathrimahalingam/CTPN.git

# Install dependencies for Caffe
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/code/CTPN/caffe

WORKDIR ${CAFFE_ROOT}

# Copy to Makefile.config
RUN cd ${CAFFE_ROOT} && cp Makefile.config.example Makefile.config

# Edit Makefile.config
RUN cd /opt/caffe/ && \
    echo "PYTHON_INCLUDE := /usr/include/python2.7 /usr/lib/python2.7/dist-packages/numpy/core/include" >> Makefile.config && \
    echo "WITH_PYTHON_LAYER := 1" >> Makefile.config && \
    echo "INCLUDE_DIRS := \$(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial" >> Makefile.config && \
    echo "LIBRARY_DIRS := \$(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial" >> Makefile.config


