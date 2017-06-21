FROM rubygem/github-markdown-preview as prep

SHELL ["bash", "-o", "pipefail", "-euc"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
            libicu-dev cmake

RUN gem install --no-rdoc --no-ri github-linguist:3.3.1 rugged:0.23.0

ENV GOSU_VERSION 1.10
RUN apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \

    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \

    # verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \

    chmod +x /usr/local/bin/gosu; \
    # verify that the binary works
    gosu nobody true

ADD github-markdown-render entrypoint.bsh /
RUN chmod 755 /github-markdown-render /entrypoint.bsh

FROM ruby:2.4.0-slim

COPY --from=prep /usr/local /usr/local

SHELL ["bash", "-o", "pipefail", "-euc"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
            libcurl3 libicu52 libxml2 python; \
    rm -rf /var/lib/apt/lists/*

COPY --from=prep /usr/local/bin/gosu /github-markdown-render /entrypoint.bsh /usr/local/bin/

WORKDIR /src
ENTRYPOINT ["/usr/local/bin/entrypoint.bsh"]
CMD ["github-markdown-render", "-o", "/out", "."]
