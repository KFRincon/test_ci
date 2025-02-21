# Etapa de construcción
FROM node:20-alpine AS builder

WORKDIR /src

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa final (solo con dependencias de producción)
FROM node:20-alpine

WORKDIR /src

COPY package.json package-lock.json ./
RUN npm install --production

COPY --from=builder /src/.next .next
COPY --from=builder /src/public public
COPY --from=builder /src/node_modules node_modules
COPY --from=builder /src/package.json package.json

EXPOSE 3000

CMD ["npm", "start"]


RUN apk add --no-cache git
