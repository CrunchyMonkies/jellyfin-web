# CrunchyMonkies jellyfin-web image: builds the web client and serves it from nginx at /web.
# Paired with the headless CrunchyMonkies/jellyfin server image; a Gateway/HTTPRoute sends
# /web* here and everything else to the Jellyfin API, so the SPA reaches the API same-origin.
# syntax=docker/dockerfile:1

FROM node:24-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build:production

FROM nginx:alpine
COPY --from=build /src/dist /usr/share/nginx/html/web
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
