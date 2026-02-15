# =========================
# Base Node 20 Debian slim
# =========================
FROM node:20-slim

# =========================
# Diretório de trabalho
# =========================
WORKDIR /app

# =========================
# Instalar Python 3.11, Java 17 e dependências de build
# =========================
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip \
    openjdk-17-jre-headless \
    build-essential \
    libpq-dev \
    gfortran \
    libffi-dev \
    libfreetype6-dev \
    libpng-dev \
    bash \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Criar virtualenv e instalar dependências Python
# =========================
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir \
        fastapi \
        uvicorn \
        pandas \
        numpy \
        psycopg2-binary \
        httpx \
        pydantic \
        lxml \
        python-multipart \
        python-docx \
        cryptography \
        signxml \
        zeep \
        beautifulsoup4 \
        matplotlib \
        pymongo \
        pyopenssl

# =========================
# Definir venv como default
# =========================
ENV PATH="/opt/venv/bin:$PATH"

# =========================
# Copiar e instalar dependências Node
# =========================
COPY package.json package-lock.json* ./
RUN npm install --production

# =========================
# Copiar código do projeto
# =========================
COPY . .

# =========================
# Build do projeto Node
# =========================
RUN npm run build

# =========================
# Variáveis de ambiente
# =========================
ENV NODE_ENV=production
ENV PORT=5000

# =========================
# Porta exposta
# =========================
EXPOSE 5000

# =========================
# Comando de inicialização
# =========================
CMD ["node", "dist/index.cjs"]
