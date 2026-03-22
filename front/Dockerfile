# syntax=docker/dockerfile:1

FROM node:20-alpine AS build
WORKDIR /app
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
ARG VITE_APP_API_GATEWAY_URL=""
ENV VITE_APP_API_GATEWAY_URL="${VITE_APP_API_GATEWAY_URL}"
RUN pnpm build

FROM nginx:1.27-alpine AS runtime
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -q -O /dev/null http://localhost/ || exit 1
