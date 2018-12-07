FROM ubuntu:bionic

MAINTAINER Shapovalov Alexandr <alex_sh@kodeks.ru>

RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends language-pack-ru-base locales
RUN sed -i 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen && update-locale LANG=ru_RU.UTF-8
RUN echo "LANGUAGE=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=ru_RU.UTF-8" >> /etc/default/locale

ENV LANGUAGE=ru_RU.UTF-8
ENV LC_ALL=ru_RU.UTF-8
ENV LC_CTYPE=ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8
ENV TERM xterm
RUN dpkg-reconfigure --frontend noninteractive locales

#####################################
# Non-Root User:
#####################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID workspace && \
useradd -u $PUID -g  workspace -m  workspace && \
usermod -p "*" workspace

#####################################
# Set Timezone
#####################################
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install "software-properties-common" (for the "add-apt-repository")
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    dnsutils iputils-ping \
    sudo

#####################################
# Setup PHP
#####################################

# Add the "PHP 7" ppa
RUN add-apt-repository -y \
    ppa:ondrej/php

# Install PHP-CLI 7, some PHP extentions and some useful Tools with APT
RUN apt-get update && apt-get install -y \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-json \
        php7.1-xml \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-mysql \
        php7.1-pgsql \
        php7.1-sqlite \
        php7.1-sqlite3 \
        php7.1-zip \
        php7.1-gd \
        php7.1-memcached \
        php7.1-tidy \
        php7.1-bcmath \
        sqlite3 \
        libsqlite3-dev \
        git \
        curl \
        wget \
        vim \
        nano \
        nodejs \
        nodejs-dev \
        npm \
        zsh \
        php-imagick


#####################################
# ZSH
#####################################
COPY .zshrc /home/workspace/
RUN chown workspace:  /home/workspace/.zshrc

USER workspace
#RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Add an alias for PHPUnit
RUN echo "alias phpunit='./vendor/bin/phpunit'" >> ~/.zshrc

#####################################
# NodeJS
#####################################
USER root

# Install gulp and bower with NPM
RUN npm install -g \
    gulp \
    bower \
    n

RUN n 5.10.0

#####################################
# Install Composer
#####################################

USER root
RUN wget https://getcomposer.org/download/1.7.2/composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN usermod -aG sudo workspace
RUN sed -i 's/\%sudo.*/\%sudo     ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers

# ENV gen
COPY env.php /var/utils/
COPY gulpfile.js /var/utils/

WORKDIR /var/utils/
RUN npm install gulp gulp-run gulp-watch

# Clean up
USER root

USER workspace
RUN /usr/local/bin/composer global require "hirak/prestissimo:^0.2"

#zsh as shell
RUN sudo chsh -s /usr/bin/zsh workspace

WORKDIR /var/www
CMD ["su", "-", "workspace", "-c", "/usr/bin/zsh"]
