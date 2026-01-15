FROM docker.io/node:lts-alpine

RUN apk add --no-cache openssl
ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN addgroup --system api && \
          adduser --system -G api api

COPY app/dist/api api

# FIX 1 : On copie le schéma Prisma
COPY app/src/prisma/schema.prisma api/schema.prisma

RUN chown -R api:api .

WORKDIR /app/api

# FIX 2 : Installation des dépendances de prod
RUN npm install --omit=dev -f

# FIX 3 : On installe la VERSION EXACTE de Prisma (v4.16.1) compatible avec le projet
RUN npm install -D prisma@4.16.1
RUN npx prisma generate --schema=./schema.prisma

CMD [ "node", "." ]