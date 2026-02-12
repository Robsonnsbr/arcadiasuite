FROM node:20-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip \
    openjdk-17-jdk \
    git build-essential curl pkg-config libpng-dev \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install
RUN npm install -g npm@latest
RUN npm install -g tsx      # <- resolve o "tsx not found"

COPY python-service/requirements.txt ./python-requirements.txt
RUN python3.11 -m venv .venv \
    && .venv/bin/pip install -r python-requirements.txt

COPY . .

RUN npm run build

EXPOSE 5000

CMD ["npm", "run", "start"]
