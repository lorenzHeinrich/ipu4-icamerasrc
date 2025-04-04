FROM libcamhal:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    libtool \
    pkg-config \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-tools \
    rpm \
    alien \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /icamerasrc

COPY ./icamerasrc /icamerasrc

RUN touch README && autoreconf --install \
    && CPPFLAGS="-I$LIBCAMHAL_INSTALL_DIR/include/ -I$LIBCAMHAL_INSTALL_DIR/include/api \
        -I$LIBCAMHAL_INSTALL_DIR/include/utils " LDFLAGS="-L$LIBCAMHAL_INSTALL_DIR/lib/" \
        CFLAGS="-O2" CXXFLAGS="-O2" \
        ./configure ${CONFIGURE_FLAGS} --prefix=$ICAMERASRC_INSTALL_DIR DEFAULT_CAMERA=0

RUN make -j8 && make rpm \
    && alien --to-deb ./rpm/icamerasrc*.rpm
