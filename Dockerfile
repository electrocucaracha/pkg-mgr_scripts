FROM golang:1.13-buster as builder

WORKDIR /go/src/github.com/electrocucaracha/pkg-mgr
COPY . .

ENV GO111MODULE "on"
ENV CGO_ENABLED "1"
ENV GOOS "linux"
ENV GOARCH "amd64"

RUN go build -v -tags netgo -installsuffix netgo -o /bin/pkg_mgr cmd/main.go

FROM debian:buster
MAINTAINER Victor Morales <electrocucaracha@gmail.com>

LABEL io.k8s.display-name="cURL Package Manager"
EXPOSE 3000

COPY --from=builder /bin/pkg_mgr /pkg_mgr
COPY scripts /scripts

CMD ["/pkg_mgr", "--port", "3000", "--sql-engine", "sqlite3"]
