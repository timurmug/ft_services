# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: qtamaril <qtamaril@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/19 10:16:54 by qtamaril          #+#    #+#              #
#    Updated: 2020/10/19 10:17:06 by qtamaril         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

services=("nginx")
green_bold="\n\t\t\e[92m\e[1m"
yellow="\e[93m"
default="\e[39m\e[0m\n"
blue="\e[24m: \e[96m"
underline="\e[4m"

printf "${green_bold}Starting minikube and creating cluster on virtualbox${default}"
minikube start --vm-driver=virtualbox
ssh-keygen -f "/Users/qtamaril/.ssh/known_hosts" -R 192.168.99.101 
eval $(minikube docker-env)

minikube addons enable metallb
kubectl apply -f srcs/yaml_files/metallb.yaml

for service in "${services[@]}"
do
printf "${green_bold}\tBuilding ${service} image...${default}"
docker build -t "${service}" srcs/${service}
printf "${yellow}${service} image builded!${default}"
done

printf "${green_bold}Creating a Volume for storage...${default}"
printf "${yellow}"
kubectl apply -f srcs/yaml_files/volume.yaml
printf "${default}"

printf "${green_bold}Creating pods based on images with yaml files...${default}"
printf "${yellow}"
for service in "${services[@]}"
do
kubectl apply -f srcs/yaml_files/${service}.yaml
done
printf "${default}"

printf "${underline}Ip address nginx${blue}192.168.99.101:443${default}"
