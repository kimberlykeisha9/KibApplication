import json
import firebase_admin
import requests
from firebase_admin import credentials, firestore, messaging
from flask import Flask, jsonify, render_template, request

cred = credentials.Certificate(
    'C:/Users/Kim/Desktop/kib_server/serviceAccountKey_worker.json')

default_app = firebase_admin.initialize_app(cred)

db = firestore.client()

app = Flask(__name__, template_folder='C:/Users/Kim/Desktop/kib_server')


def on_snapshot(col_snapshot, changes, read_time):
    print(u'Current available users: '),
    for doc in col_snapshot:
        print('User ' + doc.id + ' is available')
        print(doc.get('token'))
        message = messaging.Message(
            notification=messaging.Notification(
                title='Someone has a job for you',
                body='Click to find out more'
            ),
            data={
                'type': 'job'
            },
            token=doc.get('token')
        )
        messaging.send(message)


col_query = db.collection(u'users').where(u'is_engaged', u'==', False)


@ app.route('/listen', methods=['POST', 'GET'])
def send_notification():
    data = request.json
    print(data)
    print('Available user: ' + data['receiver'])
    messaging.send(messaging.Message(
        notification=messaging.Notification(
            title=data['message']['notification']['title'],
            body=data['message']['notification']['body'],
        ),
        token=data['message']['token']
    ),)
    return 'Sent a notification to ' + data['receiver'] + ' by user ' + data['message']['data']['uid'], 200


@ app.route('/client_payment', methods=['POST', 'GET'])
def make_client_payment():
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer df0JWHydXf0UpiHSfHApdNsnNWoh'
    }

    payload = {
        "BusinessShortCode": 174379,
        "Password": "pa6o8Sr44bPiqNUcPV61uvJwQwsYOKIsn2J7GXfq6/hJx3hGJ52QDREWTYgUVT+pq3sHOlIbPCIC4tSvduoRFSjS6XISQZyR1OJr9NT5TgcR1XwWTym7U6NA0dRtdGDSP3wuw00/7HoRDfNgYeTnLvOBbV9rhaKLaRxEkQhQPt9JWIawKHG8wXC4G3evXqdqvSdzs2IlkBh94tNGztfpptZPcYjiobeE5W0yZBiVXFBdKx4cca3wpxfOsWDhGQQSbAaK5O5tdxqEiQEAyMeK/HnEEHBfRRlOGBzV70/Laz3EBLLQZ45PgWWf4nY+qZ8fkApbnAr6iNopspyZDIaPDA==",
        "Timestamp": "20220208162827",
        "TransactionType": "CustomerPayBillOnline",
        "Amount": 1,
        "PartyA": 254795577084,
        "PartyB": 174379,
        "PhoneNumber": 254795577084,
        "CallBackURL": "http://192.168.100.240:5000/client_payment",
        "AccountReference": "CompanyXLTD",
        "TransactionDesc": "Payment of X"
    }

    response = requests.request("POST", 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest', headers = headers, data = payload)
    print(response.text)
    return response.text


@ app.route('/')
def hello():
    return render_template('index.html')


if __name__ == '__main__':
    # run app in debug mode on port 5000
    app.run(debug=True, port=5000, host="0.0.0.0")
