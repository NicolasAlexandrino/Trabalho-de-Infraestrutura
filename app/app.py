from flask import Flask, jsonify, request

# Inicializa o aplicativo Flask
app = Flask(__name__)

# Rota principal - verificação de status da API
@app.route("/")
def index():
    return jsonify({
        "message": "API de teste - Infraestrutura",
        "status": "ok"
    })


# Rota para soma de dois números
@app.route("/sum", methods=["POST"])
def soma():
    data = request.get_json() or {}
    a = data.get("a", 0)
    b = data.get("b", 0)

    try:
        s = float(a) + float(b)
        return jsonify({
            "a": a,
            "b": b,
            "sum": s
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400


# Executa o servidor
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
