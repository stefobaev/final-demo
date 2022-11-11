from flask import Flask, render_template
import random

app = Flask(__name__)

# list of cat images
images = [
    "https://c.tenor.com/borbYQNYXQ4AAAAM/fighting.gif",
    "https://c.tenor.com/cRtj5tALYaMAAAAM/json-error-computer.gif",
    "https://c.tenor.com/W-iD9IenPZwAAAAM/angry-panda.gif",
    "https://c.tenor.com/pIPJ7mJZ2bUAAAAM/man-destroys-pc-harold-slikk-new.gif",
    "https://c.tenor.com/QrqIE5XUDDwAAAAM/programmer-bug.gif",
    "https://c.tenor.com/YHUOSFkcNCcAAAAM/system-engineer-geek.gif",
    "https://c.tenor.com/JIS_KDKKsgYAAAAM/guaton-computadora.gif",
    "https://c.tenor.com/k1tDp7A1ys8AAAAM/programmer-developer.gif",
    "https://c.tenor.com/VrzXhtoSwcsAAAAM/hacker-typing.gif",
    "https://c.tenor.com/41I-iMyClCgAAAAM/programmer-programming.gif"
]

@app.route('/')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
