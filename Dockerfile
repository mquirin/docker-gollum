FROM ubuntu:20.04

MAINTAINER Takahiro Suzuki <suttang@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt update
RUN apt upgrade -y
RUN apt install -y -q build-essential ruby-full wget pkg-config libssl-dev zlib1g-dev

# Install cmake in the most hacky way imaginable
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Linux-x86_64.sh -P /tmp
RUN chmod +x /tmp/cmake-*-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /tmp/cmake-*-Linux-x86_64.sh --skip-license --prefix=/opt/cmake
RUN ln -s /opt/cmake/bin/cmake /usr/bin/cmake

# do we need all this? 
# RUN apt install -y -q python python-docutils ruby-bundler libicu-dev libreadline-dev libssl-dev zlib1g-dev git-core

# Install gollum
RUN gem install -N gollum redcarpet github-markdown

# cleanup
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


# Initialize wiki data
RUN mkdir /root/wikidata
RUN git init /root/wikidata

# Expose default gollum port 4567
EXPOSE 4567

ENTRYPOINT ["/usr/local/bin/gollum", "/root/wikidata"]
