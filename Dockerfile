FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

ARG ODOUSER=odo
ARG HOMEDIR=/home/$ODOUSER
ARG ODOMINER=$HOMEDIR/odo-miner

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

RUN mkdir $ODOMINER
WORKDIR $ODOMINER
ADD src $ODOMINER/src

ARG CYCLONEV_OF=$ODOMINER/src/projects/cyclone_v_gx_starter_kit/output_files/
ARG DE10_OF=$ODOMINER/src/projects/de10_nano/output_files/

RUN mkdir -p $CYCLONEV_OF && mkdir -p $DE10_OF

COPY odo-epochs/cyclone_v_gx_starter_kit/testnet/*.sof $CYCLONEV_OF
COPY odo-epochs/cyclone_v_gx_starter_kit/mainnet/*.sof $CYCLONEV_OF
COPY odo-epochs/de10_nano/testnet/*.sof $DE10_OF
COPY odo-epochs/de10_nano/mainnet/*.sof $DE10_OF

ADD init.sh /init.sh
RUN chown -R $ODOUSER:$ODOUSER $ODOMINER

USER $ODOUSER

CMD ["/init.sh"]
