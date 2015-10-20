FROM ubuntu:15.10
MAINTAINER Oz Akan

#######
# version aws-cli/1.8.13 Python/2.7.10
#######

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y python-pip groff libffi-dev libssl-dev zip curl
RUN pip install awscli
RUN pip install requests[security]

RUN apt-get install git -y

ADD clone.sh /usr/local/bin/clone.sh
RUN chmod 755 /usr/local/bin/clone.sh

CMD clone.sh
