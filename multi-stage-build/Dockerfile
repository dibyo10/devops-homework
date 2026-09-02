FROM alpine:3.22 AS content

WORKDIR /build
COPY index.html .
RUN sed -i 's/[[:space:]]\+$//' index.html

FROM node:22-alpine

WORKDIR /app
COPY server.js .
COPY --from=content /build/index.html .

EXPOSE 8080
USER node
CMD ["node", "server.js"]

