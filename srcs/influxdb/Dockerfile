# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: qtamaril <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/29 11:13:41 by qtamaril          #+#    #+#              #
#    Updated: 2020/10/29 11:13:43 by qtamaril         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM	    alpine:latest

RUN		    apk update 

# install
RUN         apk add --no-cache  supervisor \
                                ca-certificates \
                                influxdb

# copy supervisor config
COPY	    srcs/supervisord.conf /etc/supervisord.conf

# download lib
RUN		    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN		    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
RUN		    apk add glibc-2.32-r0.apk
RUN		    rm -f glibc-2.32-r0.apk

# download telegraf
RUN		    wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.3_linux_amd64.tar.gz
RUN		    tar xvfz telegraf-1.15.3_linux_amd64.tar.gz
RUN         rm -f telegraf-1.15.3_linux_amd64.tar.gz
RUN		    cp -r /telegraf-1.15.3/* /
RUN		    ./usr/bin/telegraf  -sample-config \
                                --input-filter docker \
                                --output-filter influxdb > /etc/telegraf/telegraf.conf

# create a mount point to work with persistent storage
VOLUME		["/var/lib"]

# set listening port
EXPOSE      8086

# start supervisor
ENTRYPOINT	/usr/bin/supervisord