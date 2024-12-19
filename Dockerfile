
FROM node:19-alpine3.15 as dev
WORKDIR /app
COPY package.json package.json
# --frozen congela las versiones que se utilizan para evitar cambios
RUN yarn install
CMD [ "yarn","start:dev" ]

FROM node:19-alpine3.15 as dev-deps
WORKDIR /app
COPY package.json package.json
# --frozen congela las versiones que se utilizan para evitar cambios
RUN yarn install --frozen-lockfile


FROM node:19-alpine3.15 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
# copia todo lo que no este ignorado en dockerignore
COPY . .
# RUN yarn test
# construye la carpeta de prod
RUN yarn build

FROM node:19-alpine3.15 as prod-deps
WORKDIR /app
COPY package.json package.json
# comando para tener solo las dependencias de prod
RUN yarn install --prod --frozen-lockfile


FROM node:19-alpine3.15 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]

