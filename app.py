from flask import Flask, Response
import datetime

app = Flask(__name__)

@app.route("/")
def get_current_time():
    # Use UTC time for consistency across systems
    current_time = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")
    return Response(f"Current UTC time is: {current_time}", mimetype='text/plain')

@app.route("/health")
def health_check():
    return Response("OK", mimetype='text/plain')

if __name__ == "__main__":
    # Run the app with debug mode on for development
    app.run(host="0.0.0.0", port=8080, debug=True)