FROM node:18-buster-slim as build-image

RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates \
    apt-transport-https xvfb \
    g++ make cmake unzip python3 \
    libcurl4-openssl-dev autoconf libtool \
    && rm -rf /var/lib/apt/lists/*

ARG FUNCTION_DIR="/function"

WORKDIR ${FUNCTION_DIR}

COPY package*.json ./

RUN npm install aws-lambda-ric

RUN npm install

COPY . .

FROM node:18-buster-slim

ENV NPM_CONFIG_CACHE=/tmp/.npm

RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable xvfb \
    && rm -rf /var/lib/apt/lists/*

ARG FUNCTION_DIR="/function"

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]

CMD ["node","app.js"]
