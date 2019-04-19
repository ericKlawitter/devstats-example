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
RUN apt-get install -y postgresql-client postgresql-9.6 sudo gosu
ENV PG_MAJOR 9.6
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
RUN adduser postgres sudo

#DEVSTATS INSTALLATION
RUN mkdir -p ${GOPATH}/src
WORKDIR ${GOPATH}/src
RUN git clone https://github.com/ericKlawitter/devstats.git
WORKDIR ${GOPATH}/src/devstats
RUN make
RUN make install
RUN chmod +x scripts/setup_db.sh
RUN chmod +x scripts/setup_mount.sh
