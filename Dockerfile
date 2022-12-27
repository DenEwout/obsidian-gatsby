FROM node:slim as prepare

RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y chromium

FROM prepare as build

COPY gatsby /app
WORKDIR /app

RUN npm install --legacy-peer-deps
WORKDIR /app/node_modules/puppeteer
RUN npm install
WORKDIR /app
RUN npm run build

FROM nginx as web
COPY --from=build /app/public /usr/share/nginx/html
