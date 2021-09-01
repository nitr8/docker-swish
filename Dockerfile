FROM debian:stretch
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list

# Install Dependencies
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y git build-essential supervisor vim-tiny apache2 libcgi-session-perl

# Swish-E
RUN git clone https://github.com/swish-e/swish-e.git \
&& cd swish-e \
&& ./configure --enable-incremental \
&& make \
&& make install

RUN echo /usr/local/lib >> /etc/ld.so.conf \
&& ldconfig

# Configure Apache
RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD configs/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Add volumes & expose ports
VOLUME  ["/var/www/html/" ]
EXPOSE 80 9001

# Start Supervisor
ADD configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/start.sh /sbin/init
RUN chmod +x /sbin/init
CMD ["/sbin/init"]

# Clean up APT when done.
#RUN apt-get clean \
# && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/www/html/docs \
#&& mkdir /var/www/listing \
&& rm -Rf /var/www/html/index.html \
&& cp -r /usr/local/lib/swish-e /var/www/html/test
#&& cp -r /usr/local/lib/swish-e /var/www/swish \
#&& chown -R 755 /var/www/test/swish.cgi
COPY configs/docs/ /var/www/html/docs/
ADD configs/listing /var/www/html/listing
ADD configs/example /var/www/html/example
COPY configs/htaccess.txt /var/www/html/.htaccess
COPY configs/htaccess.txt /var/www/html/docs/.htaccess

COPY configs/test.cgi /var/www/html/test/
COPY configs/test.cgi /usr/local/lib/swish-e/
RUN chown -R 755 /usr/local/lib/swish-e/swish.cgi \
&& chown -R 755 /var/www/html/test/test.cgi

COPY configs/swishcgi.conf /var/www/html/test/.swishcgi.conf
COPY configs/swish.config /var/www/html/test/

RUN a2enmod cgid