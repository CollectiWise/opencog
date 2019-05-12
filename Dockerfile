FROM ubuntu:cosmic

# RUN apt-get update && apt-get install curl -y && apt-get update && apt-get install wget -y && apt-get update 

# RUN apt-get update && apt-get -y install cmake libblkid-dev e2fslibs-dev libboost-all-dev libaudit-dev && apt-get update 
# RUN apt-get update && apt-get -y install lsb-core
# && apt-get install python-pip -y && pip install --upgrade pip && python -m pip uninstall pip -y 

RUN apt-get update -y && apt-get install -y libunistring-dev \
   git \
   build-essential \
   cmake \
   wget
# For Guile
RUN apt-get update -y && apt-get install -y libgmp-dev \
   libreadline-dev \
   libffi-dev \
   libgc-dev
# For OpenCog
RUN apt-get update -y && apt-get install -y libboost-all-dev \
   cython \
   cython3 \
   libpq-dev

RUN mkdir -p Sources
WORKDIR Sources
RUN wget https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz
RUN tar xvf guile-2.2.4.tar.xz
WORKDIR guile-2.2.4
RUN ./configure
RUN make -j4
RUN make install
WORKDIR /root

RUN git clone https://github.com/opencog/cogutil.git
WORKDIR cogutil
RUN mkdir -p build
WORKDIR build
RUN cmake ..
RUN make -j4
RUN make install
WORKDIR /root

RUN ldconfig

RUN git clone https://github.com/opencog/atomspace.git
WORKDIR atomspace
RUN mkdir -p build
WORKDIR build
RUN cmake ..
RUN make -j4
RUN make install
WORKDIR /root

ENV PYTHONPATH "${PYTONPATH}:/usr/local/lib/python3/dist-packages/"

RUN git clone https://github.com/opencog/opencog.git
WORKDIR opencog
RUN mkdir -p build
WORKDIR build
RUN cmake ..
RUN make -j4
RUN make install
WORKDIR /root


