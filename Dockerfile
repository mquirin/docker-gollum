FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update -q \
    && apt-get install -y -q build-essential cmake git-core libssl-dev pkg-config ruby ruby-bundler ruby-dev zlib1g-dev

# Install commonmarker rendering engine
RUN gem install -N -q commonmarker

# Install gollum from source
RUN mkdir /opt/gollum-src \
    && git clone https://github.com/mquirin/gollum /opt/gollum-src \
    && (cd /opt/gollum-src && \
        git checkout tags/v5.0.1.native && \
        bundle install)

# Expose default gollum port 4567
EXPOSE 4567
RUN mkdir /root/wikidata
CMD ["/opt/gollum-src/bin/gollum", "/root/wikidata", "--allow-uploads", "page", "--mathjax", "--emoji" ]

