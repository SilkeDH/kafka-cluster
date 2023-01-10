FROM ubuntu:latest

RUN apt-get update &&\ 
    apt-get dist-upgrade

RUN apt-get install -y gnupg software-properties-common curl

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

RUN apt-get update &&\ 
    apt-get install -y terraform python3-pip zip unzip openssh-client

RUN pip3 install ansible confluent-kafka && ansible-galaxy collection install confluent.platform

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && ./aws/install

WORKDIR /kafka-mvp

COPY . . 

RUN mkdir -p /root/.ssh
COPY secrets/kafka-key.pem /root/.ssh 
RUN chmod 400 /root/.ssh/kafka-key.pem

RUN chmod u+x client/consumer.py && chmod u+x client/producer.py

CMD ["/bin/bash"]
