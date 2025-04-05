# Crear imágenes en base a proyectos existentes

Utilizaremos este repo de teslo-shop para ver el paso a paso de como crear una imagen desde un proyecto ya existente
También hacemos un build para desarrollo o prod con docker-compose específicos

## Levantar en local Teslo API

1. Clonar proyecto
2. ```yarn install```
3. Clonar el archivo ```.env.template``` y renombrarlo a ```.env```
4. Cambiar las variables de entorno
5. Levantar la base de datos

    docker-compose up -d
    ó
    docker compose up -d

6. Levantar: `yarn start:dev`

7. Ejecutar SEED

    [local](http://localhost:3000/api/seed)

## Generar build de producción usando docker-compose especifico y levantar para probar

```bash
    # Generar el build
    docker compose -f docker-compose.prod.yml build

    # Levantar el build de prod
    docker compose -f docker-compose.prod.yml up
```

## Comando para usar con Docker

docker container run `
--name nest-app `
-w /app `
-p 80:3000 `
-v ${PWD}:/app `
node:16-alpine3.16 `
sh -c "yarn install && yarn start:dev"
