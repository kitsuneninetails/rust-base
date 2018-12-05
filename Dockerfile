FROM ubuntu:xenial

WORKDIR /root

# common packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python curl unzip \
        ca-certificates curl file \
        g++ ssh \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && rm -rf awscli-bundle

ENV SSL_VERSION=1.1.0f

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION &&  \
    ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib -fPIC && \
    make depend && make && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

ENV OPENSSL_LIB_DIR=/usr/lib \
    OPENSSL_INCLUDE_DIR=/usr/include \
    OPENSSL_STATIC=1 \
    LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:.

