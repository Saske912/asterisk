FROM debian:latest
WORKDIR /usr/local/src
RUN apt-get update -y
ADD https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20.1.0.tar.gz .
RUN tar -zxvf asterisk-20.1.0.tar.gz
WORKDIR /usr/local/src/asterisk-20.1.0/contrib/scripts
RUN ./install_prereq install
WORKDIR /usr/local/src/asterisk-20.1.0
RUN ./configure
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
    menuselect.makeopts && \
    make && \
    make install && \
    make config && \
    make install-logrotate && \
    make basic-pbx
WORKDIR /usr/local/src/asterisk-20.1.0/contrib/ast-db-manage
ADD https://bootstrap.pypa.io/get-pip.py .
RUN python3 get-pip.py && pip install alembic
ENTRYPOINT ["/usr/sbin/asterisk"]
CMD ["-c", "-vvvv", "-g"]
