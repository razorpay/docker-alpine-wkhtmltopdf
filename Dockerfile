FROM alpine:3.5
MAINTAINER Razorpay Developers <developers@razorpay.com>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories  && \
	apk add --update --no-cache \
	git patch gtk+ openssl glib \
	make g++ glib-dev gtk+-dev mesa-dev openssl-dev \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    libcrypto1.0 libssl1.0 \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family 

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/archive/0.12.4.tar.gz && \
	mv 0.12.4.tar.gz wkhtmltopdf.tar.gz && \
	tar xvf wkhtmltopdf.tar.gz && \
	mv wkhtmltopdf-0.12.4 /tmp/wkhtmltopdf && \
	wget https://github.com/wkhtmltopdf/qt/archive/c0cfa03a072789550d8ff5724b2e5e58436e02d1.zip -Oqt.zip

RUN unzip qt.zip && \
	mv qt-c0cfa03a072789550d8ff5724b2e5e58436e02d1 /tmp/wkhtmltopdf/qt

RUN mv /tmp/wkhtmltopdf/qt/qt-c0cfa03a072789550d8ff5724b2e5e58436e02d1 qt-c0cfa03a072789550d8ff5724b2e5e58436e02d1 && \
	rmdir /tmp/wkhtmltopdf/qt && \
	mv qt-c0cfa03a072789550d8ff5724b2e5e58436e02d1 /tmp/wkhtmltopdf/qt && \
	ls -al

COPY conf/* /tmp/wkhtmltopdf/qt/

RUN cd /tmp/wkhtmltopdf/qt && \
	ls -al && \
    patch -p1 -i qt-musl.patch && \
    patch -p1 -i qt-musl-iconv-no-bom.patch && \
    patch -p1 -i qt-recursive-global-mutex.patch && \
    patch -p1 -i qt-font-pixel-size.patch && \
    sed -i "s|-O2|$CXXFLAGS|" mkspecs/common/g++.conf && \
    sed -i "/^QMAKE_RPATH/s| -Wl,-rpath,||g" mkspecs/common/g++.conf && \
    sed -i "/^QMAKE_LFLAGS\s/s|+=|+= $LDFLAGS|g" mkspecs/common/g++.conf && \
    CFLAGS=-w CPPFLAGS=-w CXXFLAGS=-w LDFLAGS=-w ./configure -confirm-license -opensource \
    	-prefix /usr \
    	-datadir /usr/share/qt \
    	-sysconfdir /etc \
    	-plugindir /usr/lib/qt/plugins \
    	-importdir /usr/lib/qt/imports \
    	-fast \
    	-release \
    	-static \
    	-largefile \
    	-glib \
    	-graphicssystem raster \
    	-qt-zlib \
    	-qt-libpng \
    	-qt-libmng \
    	-qt-libtiff \
    	-qt-libjpeg \
    	-svg \
    	-webkit \
    	-gtkstyle \
    	-xmlpatterns \
    	-script \
    	-scripttools \
    	-openssl-linked \
    	-nomake demos \
    	-nomake docs \
    	-nomake examples \
    	-nomake tools \
    	-nomake tests \
    	-nomake translations \
    	-no-qt3support \
    	-no-pch \
    	-no-icu \
    	-no-phonon \
    	-no-phonon-backend \
    	-no-rpath \
    	-no-separate-debug-info \
    	-no-dbus \
    	-no-opengl \
    	-no-openvg && \
    make --silent && \
    make install && \
    cd /tmp/wkhtmltopdf && \
    qmake && \
    make --silent && \
    make install && \
    rm -rf /tmp/* && \
    apk del --update \
	make g++ glib-dev gtk+-dev mesa-dev openssl-dev && \
	rm -rf /var/cache/apk/*

# on alpine static compiled patched qt headless wkhtmltopdf (47.2 MB)
# compilation takes 4 hours on EC2 m1.large in 2016 thats why binary
# COPY wkhtmltopdf /bin

ENTRYPOINT ["sh"]
