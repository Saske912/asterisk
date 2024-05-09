FROM debian:latest
WORKDIR /usr/local/src
RUN apt-get update -y
RUN apt -y install fail2ban curl gzip sipsak
ENV BCG729_VERSION=1.0.4 \
    SPANDSP_VERSION=20180108
ADD https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20.1.0.tar.gz .
RUN tar -zxvf asterisk-20.1.0.tar.gz
WORKDIR /usr/local/src/asterisk-20.1.0/contrib/scripts
RUN ./install_prereq install
WORKDIR /usr/local/src/asterisk-20.1.0
RUN ./configure \
    --with-spandsp \
    --with-srtp \
    --with-ldap
RUN make menuselect.makeopts && \
    menuselect/menuselect \
    --enable codec_opus \
    --enable codec_silk \
    --enable codec_siren7 \
    --enable codec_siren14 \
    # --enable codec_g729a \
    --disable CORE-SOUNDS-EN-GSM \
    --enable CORE-SOUNDS-RU-WAV \
    --enable CORE-SOUNDS-RU-G722 \
    --disable codec_g729a && \
    menuselect.makeopts && \
    make && \
    make install && \
    make config && \
    make install-logrotate && \
    make basic-pbx

#### Add G729 codecs
git clone https://github.com/BelledonneCommunications/bcg729 /usr/src/bcg729 && \
cd /usr/src/bcg729 && \
git checkout tags/$BCG729_VERSION && \
./autogen.sh && \
./configure --prefix=/usr --libdir=/lib && \
make && \
make install && \
\
mkdir -p /usr/src/asterisk-g72x && \
curl https://bitbucket.org/arkadi/asterisk-g72x/get/master.tar.gz | tar xvfz - --strip 1 -C /usr/src/asterisk-g72x && \
cd /usr/src/asterisk-g72x && \
./autogen.sh && \
./configure --prefix=/usr --with-bcg729 --enable-$G72X_CPUHOST && \
make && \
make install
WORKDIR /usr/local/src/asterisk-20.1.0/contrib/ast-db-manage
ADD https://bootstrap.pypa.io/get-pip.py .
RUN python3 get-pip.py && pip install alembic
ENTRYPOINT ["/usr/sbin/asterisk"]
CMD ["-c", "-vvvv", "-g"]
