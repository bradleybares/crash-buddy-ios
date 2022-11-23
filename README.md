## Setting up texting Emergency Contact functionality 
Ref: https://www.twilio.com/blog/2016/11/how-to-send-an-sms-from-ios-in-swift.html

We first need to make sure we have python virtual environment\
[https://python.land/virtual-environments/virtualenv](https://python.land/virtual-environments/virtualenv)

After starting the virtual environment, we must install flask while in the virtual environment:

### `pip install flask`

We must install twilio:

### `pip install twilio`

In the `server.py` file, we must add the `ACCOUNT_SID` and `AUTH_TOKEN` credentials (should be in our Slack).

Now, we can start and run our server file where we will have a local endpoint `http://127.0.0.1:5000/sms` (where you can modify this in the `CrashBuddy/Views/TextEmergencyContactView.swift` file):

### `python server.py`

To hit the local endpoint hosted by your computer, you'll need to follow these steps: https://ymoondhra.medium.com/how-to-run-localhost-on-your-iphone-4110a54d1896

In your CrashBuddy workspace, we need to install `cocoapods`

### `sudo gem install cocoapods`

To get the `Alamofire` dependency added we must download our dependencies. Your current directory should be where the Podfile is.

### `pod install`
