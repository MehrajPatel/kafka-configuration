#!/bin/bash

#####################################################
##        Author: Mehraj Patel     ##
#### note - Dont remove this section else this script won't run ;) ####
#####################################################


sudo yum install wget telnet curl which -y

#username should be provided as command line parameter
username=$1
cat $HOME/.ssh/authorized_keys >> authorized_keys
for i in `cat $HOME/hosts`
do
 ssh -i key.pem $username@$i "echo -e 'y\n' | ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa"
 ssh -i key.pem $username@$i 'touch ~/.ssh/config; echo -e \ "host *\n StrictHostKeyChecking no\n UserKnownHostsFile=/dev/null" \ > ~/.ssh/config; chmod 644 ~/.ssh/config'
 ssh -i key.pem $username@$i 'cat $HOME/.ssh/id_rsa.pub' >> authorized_keys
done

for i in `cat $HOME/hosts`
do
 scp -i key.pem authorized_keys $username@$i:$HOME/.ssh/authorized_keys
 scp -i key.pem $HOME/pre-req.sh $username@$i:$HOME/ 
 ssh $username@$i 'chmod a+x pre-req.sh'
done

for i in `cat $HOME/hosts`
do
 ssh $username@$i "sudo yum install java-1.8.0-openjdk.x86_64 -y"
 ssh $username@$i "echo 'JAVA_HOME=/usr/java/latest' | sudo tee -a /etc/profile.d/java.sh"
 ssh $username@$i "source /etc/profile.d/java.sh"
done

for i in `tac $HOME/hosts`
do 
 ssh $username@$i 'sudo bash pre-req.sh'  
done
