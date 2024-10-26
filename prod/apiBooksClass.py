from flask import Flask, jsonify, request, send_from_directory

app = Flask(__name__)

# Lista estática para armazenar os livros
livros = []

# Rota para criar um novo livro
@app.route('/livros', methods=['POST'])
def criar_livro():
    novo_livro = request.get_json()
    titulo = novo_livro.get('titulo')
    autor = novo_livro.get('autor')
    
    if not titulo or not autor:
        return jsonify({"erro": "Título e autor são obrigatórios"}), 400
    
    livro = {
        'id': len(livros) + 1,
        'titulo': titulo,
        'autor': autor
    }
    
    livros.append(livro)
    
    return jsonify(livro), 201

# Rota para listar todos os livros
@app.route('/livros', methods=['GET'])
def listar_livros():
    return jsonify(livros), 200

# Rota para servir o arquivo index.html
@app.route('/')
def index():
    return send_from_directory('', 'index.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

