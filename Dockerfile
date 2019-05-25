FROM golang:1.12-alpine as builder

RUN apk add --no-cache ca-certificates git

ENV PROJECT quizservice
WORKDIR /go/src/$PROJECT

ENV GO111MODULE on
COPY . .
RUN go install .

FROM alpine as release
RUN apk add --no-cache ca-certificates \
    busybox-extras net-tools bind-tools
WORKDIR /quizservice
COPY --from=builder /go/bin/quizservice /app/quizservice

EXPOSE 8000
ENTRYPOINT ["/app/quizservice"]