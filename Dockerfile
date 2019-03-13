FROM golang:latest

ENV GOPATH /go
ENV PATH $PATH:/etc/gha2db:/${GOPATH}/bin

RUN apt-get update -y && \
				apt-get install -y apt-transport-https \
				git psmisc jsonlint yamllint gcc

RUN go get -u github.com/golang/lint/golint && \
  go get golang.org/x/tools/cmd/goimports

RUN go get github.com/jgautheron/goconst/cmd/goconst && \
	go get github.com/jgautheron/usedexports

RUN go get github.com/kisielk/errcheck && \
	go get github.com/lib/pq

RUN go get golang.org/x/text/transform && \
	go get golang.org/x/text/unicode/norm

RUN go get github.com/google/go-github/github && \
	go get golang.org/x/oauth2

RUN go get gopkg.in/yaml.v2 && \
	go get github.com/mattn/go-sqlite3

RUN apt-get install -y vim

#POSTGRES INSTALLATION
RUN groupadd -g 1000 postgres && \
	useradd -r -u 1000 -g postgres --create-home --shell=/bin/bash postgres
RUN apt-get install -y postgresql-client postgresql sudo gosu
RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
# TODO: Do we need t run docker_entrypoint?
RUN adduser postgres sudo
#DEVSTATS INSTALLATION

RUN mkdir -p ${GOPATH}/src
WORKDIR ${GOPATH}/src
RUN git clone https://github.com/ericKlawitter/devstats.git
WORKDIR ${GOPATH}/src/devstats
RUN make
RUN make install

ENV SRC_DIR /mount/data/src

RUN mkdir -p ${SRC_DIR}
WORKDIR ${SRC_DIR}

RUN mkdir -p /mount/data/devstats_repos
RUN git clone https://github.com/ericKlawitter/devstats-example.git devstats

WORKDIR ${SRC_DIR}/devstats
RUN ./scripts/copy_devstats_binaries.sh

RUN rm -rf /etc/gha2db/ && ln -sf /mount/data/src/devstats/ /etc/gha2db

