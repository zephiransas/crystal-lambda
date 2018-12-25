FROM crystallang/crystal:latest

RUN mkdir /lambda
WORKDIR /lambda

COPY main.cr . 
COPY build.sh . 

RUN crystal version