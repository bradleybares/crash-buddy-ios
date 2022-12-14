from flask import Flask, request

from twilio.rest import Client

app = Flask(__name__)
 
# put your own credentials here 
ACCOUNT_SID = 'ACf9066f7238f71b562f17db80ae926b22' 
AUTH_TOKEN = 'f601c1188427b724c2b27af2919e9b12'
 
client = Client(ACCOUNT_SID, AUTH_TOKEN)
 
@app.route('/sms', methods=['POST'])
def send_sms():
    message = client.messages.create(
        to=request.form['To'], 
        from_='+14254753634', 
        body=request.form['Body'],
    )

    return message.sid

if __name__ == '__main__':
        app.run(port=5005)
