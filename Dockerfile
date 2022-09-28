# FROM library/golang:1.16.5
FROM golang:1.16.5

RUN apt-get update && apt-get install openssl libssl-dev curl libcurl4-openssl-dev

RUN go env -w GOPROXY=https://goproxy.cn,direct
# Godep for vendoring
ENV GO111MODULE=on

# Recompile the standard library without CGO
RUN CGO_ENABLED=0 go install -a std
RUN go clean -modcache
RUN go get github.com/tools/godep

# RUN go get -u github.com/beego/bee/v2
RUN go get github.com/beego/bee/v2@v2.0.2



# ENV GOFLAGS=-mod=vendor


# ENV APP_USER app
# ENV APP_HOME /go/src/mathapp

RUN apt update && apt install -y protobuf-compiler
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

ENV GOPATH  /go_workspace
ENV APP_DIR $GOPATH/src/
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# RUN go mod vendor
#RUN cd $APP_DIR && CGO_ENABLED=0 godep go build -ldflags '-d -w -s'

EXPOSE 8081
EXPOSE 10443
CMD ["bee", "run","-gendoc=true","-downdoc=true"]