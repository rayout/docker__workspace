FROM ubuntu:trusty

MAINTAINER Shapovalov Alexandr <alex_sh@kodeks.ru>

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Install "software-properties-common" (for the "add-apt-repository")
RUN apt-get update && apt-get install -y \
    software-properties-common

# Add the "PHP 7" ppa
RUN add-apt-repository -y \
    ppa:ondrej/php

# Install PHP-CLI 7, some PHP extentions and some useful Tools with APT
RUN apt-get update && apt-get install -y --force-yes \
        php7.0-cli \
        php7.0-common \
        php7.0-curl \
        php7.0-json \
        php7.0-xml \
        php7.0-mbstring \
        php7.0-mcrypt \
        php7.0-mysql \
        php7.0-pgsql \
        php7.0-sqlite \
        php7.0-sqlite3 \
        php7.0-zip \
        php7.0-memcached \
        php7.0-tidy \
        sqlite3 \
        libsqlite3-dev \
        git \
        curl \
        vim \
        nano \
        nodejs \
        nodejs-dev \
        npm \
        zsh

# Clean up, to free some space
RUN apt-get clean

# Install gulp and bower with NPM
RUN npm install -g \
    gulp \
    bower

#ZSH
COPY .zshrc /root
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
&& git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k \
&& chsh -s /usr/bin/zsh


# Add a symbolic link for Node
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Add an alias for PHPUnit
RUN echo "alias phpunit='./vendor/bin/phpunit'" >> ~/.zshrc

# Install Composer
RUN curl -s http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && echo "alias composer='/usr/local/bin/composer.phar'" >> ~/.zshrc \
    && /usr/local/bin/composer.phar global require "hirak/prestissimo:^0.2"

RUN npm i -g n
RUN n 5.10.0

# Source the bash
#ENV SHELL /usr/bin/zsh

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www
CMD ["/usr/bin/zsh"]
