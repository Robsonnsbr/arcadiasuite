# =========================
# STAGE 1 — BUILDER
# =========================
FROM node:20-slim AS builder

WORKDIR /app

# Instalar dependências de build
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

# Criar virtualenv Python
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

ENV PATH="/opt/venv/bin:$PATH"

# Instalar dependências Node (inclui dev)
COPY package.json package-lock.json* ./
RUN npm install --include=dev

# Copiar projeto
COPY . .

# Build
RUN npm run build



# =========================
# STAGE 2 — RUNNER (produção)
# =========================
FROM node:20-slim

WORKDIR /app

# Instalar apenas runtime necessário
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    openjdk-17-jre-headless \
    libpq-dev \
    libffi-dev \
    libfreetype6-dev \
    libpng-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Copiar venv pronto do builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copiar apenas o necessário
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json* ./

# Instalar apenas produção
RUN npm install --omit=dev

# Variáveis
ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node", "dist/index.cjs"]
