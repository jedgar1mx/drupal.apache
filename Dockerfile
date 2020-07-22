FROM ubuntu AS production

MAINTAINER jedgar1mx

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install apt-get install -y software-properties-common -y;

ARG DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository -y ppa:ondrej/php

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=${TIME_ZONE}
RUN apt-get update && apt-get install apt-get install -yq apache2 php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-cli php7.4-common php7.4-gd php7.4-mbstring php7.4-xml php7.4-opcache php7.4-sqlite3 php7.4-mysql php7.4-curl php7.4-soap mariadb-client curl git nano zip unzip

RUN a2enmod mpm_itk
RUN a2enmod rewrite

# Setting up composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer
RUN echo export path="\$Path:/var/www/html/vendor/bin/" >> ~/.bashrc
RUN echo cd /var/www/html >> ~/.bashrc

# Forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/access.log && ln -sf /dev/stderr /var/log/apache2/error.log && ln -sf /dev/stdout /var/log/apache2/000_default-access_log && ln -sf /dev/stderr /var/log/apache2/000_default-error_log

EXPOSE 80

CMD ["apachectl" "-D" "FOREGROUND"]

FROM production AS development