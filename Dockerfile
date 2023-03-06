FROM --platform=$BUILDPLATFORM golang:1.19-alpine AS build 

ARG TARGETARCH
WORKDIR /app

# dependence
RUN go env -w GO111MODULE="on" && go env -w GOPROXY="https://goproxy.cn,direct"
COPY go.sum go.mod main.go ./
RUN go mod tidy 
# build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o myurls main.go 

FROM scratch
WORKDIR /app
COPY --from=build /app/myurls ./
COPY public/* ./public/
EXPOSE 8002
ENTRYPOINT ["/app/myurls"]
