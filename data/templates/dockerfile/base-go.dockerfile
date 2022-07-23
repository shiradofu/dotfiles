FROM golang:alpine as base
RUN mkdir /app
WORKDIR /app
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
COPY . .

FROM base as dev
RUN go get github.com/githubnemo/CompileDaemon
ENTRYPOINT CompileDaemon --build="go build -o main" --command=./main

FROM base as build
RUN go build -o main

FROM golang:alpine as prod
COPY --from=build /app/main ./
ENTRYPOINT ./main
