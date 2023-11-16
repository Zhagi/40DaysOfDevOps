from flask import Flask

application = Flask(__name__)

@application.route('/')
def CI__CD_Pipeline():
    return 'Your CI-CD Pipeline Works!'

if __name__ == '__main__':
    application.run(debug=True)