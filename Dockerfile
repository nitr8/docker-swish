FROM debian:stretch
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list

# Install Dependencies
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y git build-essential supervisor vim-tiny apache2

# Configure Apache
RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD configs/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

RUN git clone https://github.com/swish-e/swish-e.git \
&& cd swish-e \
&& ./configure --enable-incremental \
&& make \
&& make install

RUN echo /usr/local/lib >> /etc/ld.so.conf \
&& ldconfig

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
&& rm -Rf /var/www/html/index.html
COPY configs/docs/ /var/www/html/docs/
ADD configs/listing /var/www/html/listing
COPY configs/htaccess.txt /var/www/html/.htaccess
COPY configs/htaccess.txt /var/www/html/docs/.htaccess