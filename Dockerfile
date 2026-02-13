FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache \
 python3 \
 py3-pip \
 bash \
 openjdk17-jre

RUN pip3 install fastapi uvicorn

COPY package.json package-lock.json* ./
RUN npm install

COPY . .

RUN npm run build

ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node", "dist/index.cjs"]
