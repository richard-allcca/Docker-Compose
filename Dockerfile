# NOTE --frozen-lockfile (congela las versiones de dependencias para evitar cambios)

# Stage de desarrollo usado en el servicio app en docker-compose.yml
FROM node:19-alpine3.15 as dev
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile
CMD [ "yarn","start:dev" ]


FROM node:19-alpine3.15 as dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile


FROM node:19-alpine3.15 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
# copia todo lo que no este ignorado en dockerignore
COPY . .
# RUN yarn test
RUN yarn build # construye la aplicacion (carpeta dist)

FROM node:19-alpine3.15 as prod-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile # solo las dependencias de prod


FROM node:19-alpine3.15 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]
