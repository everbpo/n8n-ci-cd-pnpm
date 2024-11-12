#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Print formatted message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check command status
check_command() {
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✓ $1 completado"
    else
        print_message "$RED" "✗ Error: $1 falló"
        exit 1
    fi
}

# Paths for node user
N8N_PATH=$(npm root -g)/n8n
PROJECT_DIR="/home/node/.n8n/custom/nodes"
$CUSTOM_DIR="/home/node/.n8n/custom/"
# Create necessary directories
mkdir -p "$PROJECT_DIR"
chown -R node:node "$PROJECT_DIR"
npm install -g pnpm
npm install -g typescript
# Verify n8n installation
if [ ! -d "$N8N_PATH" ]; then
    print_message "$RED" "❌ n8n no está instalado globalmente"
    exit 1
fi

print_message "$BLUE" "🔍 Verificando directorios..."
print_message "$BLUE" "📂 N8N Path: $N8N_PATH"
print_message "$BLUE" "📂 Project Path: $PROJECT_DIR"
#Adding The JSON File to custom
json="{
  "name": "customs",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "n8n-nodes-customs-city": "file:./nodes"
  }
}";
cd $CUSTOM_DIR
echo $json > package.json

# Enter project directory
cd "$PROJECT_DIR"

# Install project dependencies
print_message "$BLUE" "📥 Instalando dependencias del proyecto..."
pnpm install
check_command "Instalación de dependencias"

# Build the project
print_message "$BLUE" "🏗️ Construyendo el proyecto..."
pnpm run build
check_command "Construcción del proyecto"

print_message "$GREEN" "🚀 Proyecto listo para usar"
