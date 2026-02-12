# 1. Base Node
FROM node:20-slim

# 2. Diretório de trabalho
WORKDIR /app

# 3. Instalar Python e Java
RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip \
    openjdk-11-jdk \
    git build-essential \
    && rm -rf /var/lib/apt/lists/*

# 4. Copiar package.json e instalar dependências Node
COPY package*.json ./
RUN npm install

# 5. Copiar requirements Python e instalar
COPY python-service/requirements.txt ./python-requirements.txt
RUN python3.11 -m venv .venv \
    && .venv/bin/pip install -r python-requirements.txt

# 6. Copiar todo código
COPY . .

# 7. Build do frontend/backend
RUN npm run build

# 8. Expor porta do Node
EXPOSE 5000

# 9. Comando padrão
CMD ["npm", "run", "start"]
