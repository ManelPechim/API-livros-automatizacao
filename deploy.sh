#!/bin/bash

# Definindo os diretórios
DEV_DIR="./dev"
PROD_DIR="./prod"
VENV_DIR="$DEV_DIR/apiBooks"

# Nome do processo da aplicação (ajuste conforme necessário)
APP_PROCESS="apiBooksClass.py"

# Repositório GIT
GIT_REPO="git@github.com:PyroPapyrus/API-livros-automatizacao.git"

# Função para verificar se um processo está rodando e matá-lo
kill_process() {
    PID=$(pgrep -f "$APP_PROCESS")
    if [ -n "$PID" ]; then
        echo "Matando o processo $APP_PROCESS com PID $PID..."
        kill -9 "$PID"
        echo "Processo $APP_PROCESS encerrado."
    else
        echo "Nenhum processo $APP_PROCESS encontrado rodando."
    fi
}

# Criando a pasta dev se ela não existir
if [ ! -d "$DEV_DIR" ]; then
    echo "A pasta $DEV_DIR não existe. Criando pasta..."
    mkdir "$DEV_DIR"
fi

# Criando a pasta prod se ela não existir
if [ ! -d "$PROD_DIR" ]; then
    echo "A pasta $PROD_DIR não existe. Criando pasta..."
    mkdir "$PROD_DIR"
fi


# Baixando a aplicação do repositório GIT
echo "Baixando a aplicação do repositório $GIT_REPO..."
cd "$DEV_DIR"
git pull origin main
if [ $? -ne 0 ]; then
    echo "Erro ao baixar a aplicação do repositório GIT."
    exit 1
fi

# Voltando ao diretório principal para continuar as operações
cd ..

# Matando o processo da aplicação que está rodando
kill_process

# Removendo os arquivos antigos da pasta prod
echo "Removendo os arquivos antigos de $PROD_DIR..."
rm -rf "$PROD_DIR/*"

# Verificando se a remoção foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Arquivos antigos removidos com sucesso."
else
    echo "Falha ao remover os arquivos antigos."
    exit 1
fi

# Verificando se existem arquivos na pasta dev
if [ -z "$(ls -A $DEV_DIR)" ]; then
    echo "A pasta $DEV_DIR está vazia. Verifique o repositório GIT."
    exit 1
fi

# Copiando os novos arquivos da pasta dev para a pasta prod
echo "Copiando arquivos de $DEV_DIR para $PROD_DIR..."
cp -r "$DEV_DIR/"* "$PROD_DIR/"

# Verificando se a cópia foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Cópia realizada com sucesso!"
else
    echo "Falha na cópia dos arquivos."
    exit 1
fi

# Mudando para o diretório prod
cd "$PROD_DIR"

# Ativando o ambiente virtual dentro da pasta dev
echo "Ativando o ambiente virtual $VENV_DIR..."
source "$VENV_DIR/bin/activate"

# Executando a aplicação Flask
echo "Executando a aplicação Flask..."
nohup python3 apiBooksClass.py &

# Verificando se a aplicação iniciou com sucesso
if [ $? -eq 0 ]; then
    echo "Aplicação iniciada com sucesso!"
else
    echo "Falha ao iniciar a aplicação."
    exit 1
fi
