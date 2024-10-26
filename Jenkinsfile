pipeline {
    agent any

    environment {
        DEV_DIR = "./dev"
        PROD_DIR = "./prod"
        VENV_DIR = "${DEV_DIR}/apiBooks"
        APP_PROCESS = "apiBooksClass.py"
        GIT_REPO = "git@github.com:PyroPapyrus/API-livros-automatizacao.git"
    }

    stages {
        stage('Preparação dos Diretórios') {
            steps {
                script {
                    // Criação das pastas dev e prod
                    if (!fileExists("${DEV_DIR}")) {
                        sh "mkdir ${DEV_DIR}"
                    }
                    if (!fileExists("${PROD_DIR}")) {
                        sh "mkdir ${PROD_DIR}"
                    }
                }
            }
        }

        stage('Clonagem do Repositório') {
            steps {
                script {
                    dir("${DEV_DIR}") {
                        // Clonando ou atualizando o repositório
                        sh "git init"
                        sh "git remote add origin ${GIT_REPO}"
                        sh "git pull origin main"
                    }
                }
            }
        }

        stage('Encerramento de Processos Atuais') {
            steps {
                script {
                    // Matando o processo antigo, se estiver rodando
                    def pid = sh(script: "pgrep -f ${APP_PROCESS}", returnStdout: true).trim()
                    if (pid) {
                        echo "Matando o processo ${APP_PROCESS} com PID ${pid}..."
                        sh "kill -9 ${pid}"
                    } else {
                        echo "Nenhum processo ${APP_PROCESS} encontrado rodando."
                    }
                }
            }
        }

        stage('Limpeza de Produção') {
            steps {
                // Removendo arquivos antigos da pasta prod
                sh "rm -rf ${PROD_DIR}/*"
            }
        }

        stage('Transferência de Arquivos para Produção') {
            steps {
                // Copiando novos arquivos da pasta dev para a pasta prod
                sh "cp -r ${DEV_DIR}/* ${PROD_DIR}/"
            }
        }

        stage('Ativação do Ambiente Virtual') {
            steps {
                // Ativando o ambiente virtual
                sh "source ${VENV_DIR}/bin/activate"
            }
        }

        stage('Execução da Aplicação') {
            steps {
                script {
                    dir("${PROD_DIR}") {
                        // Iniciando a aplicação Flask
                        sh "nohup python3 ${APP_PROCESS} &"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completa."
        }
        success {
            echo "Aplicação implantada e executada com sucesso!"
        }
        failure {
            echo "Falha durante a execução da pipeline."
        }
    }
}
