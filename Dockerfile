FROM node:20-alpine AS builder

WORKDIR /app

# Dependências de build
RUN apk add --no-cache git python3 py3-pip bash

COPY package.json package-lock.json* ./
RUN npm install

COPY . .
RUN npm run build

# Remove dev deps
RUN npm prune --omit=dev


FROM node:20-alpine AS runner

WORKDIR /app

# Runtime deps (AQUI estava o erro)
RUN apk add --no-cache python3 bash

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/migrations ./migrations
COPY --from=builder /app/shared ./shared
COPY --from=builder /app/server ./server
COPY --from=builder /app/metabase ./metabase

ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node", "dist/index.cjs"]
