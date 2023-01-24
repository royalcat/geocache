#build container
FROM golang:1.19.2 AS build
WORKDIR /app

RUN git config \
    --global \
    url."https://oauth2:qv9yq5cMx4-DWieNjs2f@gitlab.bsmg.ru".insteadOf \
    "https://gitlab.bsmg.ru"


COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /rgeocache ./cmd/main.go

# run container
FROM scratch

COPY --from=build /rgeocache /app/rgeocache
COPY data/points_data.gob /app/points-data.gob

WORKDIR /app
ENTRYPOINT [ "/app/rgeocache", "serve", "--points", "points-data.gob" ]