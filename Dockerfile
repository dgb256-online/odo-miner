FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

ARG ODOUSER=odo
ARG HOMEDIR=/home/$ODOUSER

RUN apt-get update && \
    apt-get -y install apt-utils

RUN apt-get -y install net-tools ngrep git htop \
    locales vim screen gettext \
    udev usbutils google-perftools python python-pip

RUN pip install base58 requests twisted

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -ms /bin/bash $ODOUSER
USER $ODOUSER
WORKDIR $HOMEDIR

ADD init.sh /init.sh

RUN git clone https://github.com/dgb256-online/odo-miner.git && \
    cd odo-miner && \
    git checkout docker && \
    git submodule init && \
    git submodule update

RUN cd odo-miner && \
    mkdir -p src/projects/de10_nano/output_files/ && \
    mkdir -p src/projects/cyclone_v_gx_starter_kit/output_files/ && \
    mv odo-epochs/de10_nano/testnet/*.sof src/projects/de10_nano/output_files/ && \
    mv odo-epochs/de10_nano/mainnet/*.sof src/projects/de10_nano/output_files/ && \
    mv odo-epochs/cyclone_v_gx_starter_kit/testnet/*.sof src/projects/cyclone_v_gx_starter_kit/output_files/ && \
    mv odo-epochs/cyclone_v_gx_starter_kit/mainnet/*.sof src/projects/cyclone_v_gx_starter_kit/output_files/

CMD ["/init.sh"]
