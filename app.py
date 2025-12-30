from flask import Flask, render_template_string

app = Flask(__name__)

# HTML template
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Name Display App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .name {
            font-size: 48px;
            color: #667eea;
            font-weight: bold;
            margin: 20px 0;
        }
        .info {
            color: #666;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My App!</h1>
        <div class="name">{{ name }}</div>
        <div class="info">Running in Docker Container 🐳</div>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    # You can change this name to whatever you want
    name = "Bob"
    return render_template_string(HTML_TEMPLATE, name=name)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

# Made with Bob
