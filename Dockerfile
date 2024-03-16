FROM alpine:3.19 as builder

RUN apk add gcc g++ make cmake ninja openssl-dev zlib-dev gperf linux-headers

WORKDIR /usr/src/app
COPY CMakeLists.txt .
COPY td/ ./td/
COPY telegram-bot-api ./telegram-bot-api/

RUN cmake -DCMAKE_BUILD_TYPE=Release -S . -B build -G Ninja
RUN ninja -C build

FROM alpine:3.19 as final

RUN apk add openssl zlib gperf

WORKDIR /app
COPY --from=builder /usr/src/app/build/telegram-bot-api .

ENTRYPOINT [ "/app/telegram-bot-api", "--api-id=${API_ID}", "--api-hash=${API_HASH}", "--local", "-http-port=${HTTP_PORT}" ]
