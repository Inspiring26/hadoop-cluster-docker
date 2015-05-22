#!/bin/bash

# run N slave containers
N=$1

# the defaut slave number is 2
if [ $# = 0 ]
then
	N=2
fi
	

# start master container
sudo docker run -d -t --dns 127.0.0.1 -P --name master -h master.kiwenlau.com -w /root kiwenlau/hadoop-master:0.1.0

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master)

i=1
while [ $i -le $N ]
do
	sudo docker run -d -t --dns 127.0.0.1 -P --name slave$i -h slave$i.kiwenlau.com -e JOIN_IP=$FIRST_IP kiwenlau/hadoop-slave:0.1.0
	((i++))
done 

# start slave1 container
#sudo docker run -d -t --dns 127.0.0.1 -P --name slave1 -h slave1.kiwenlau.com -e JOIN_IP=$FIRST_IP kiwenlau/hadoop-slave:0.1.0

# start slave2 container
#sudo docker run -d -t --dns 127.0.0.1 -P --name slave2 -h slave2.kiwenlau.com -e JOIN_IP=$FIRST_IP kiwenlau/hadoop-slave:0.1.0

# create a new Bash session in the master container
sudo docker exec -it master bash
