import os

if os.environ.get("MIX_ENV") == "prod":
    base_url = "https://www.youtube.com"
else:
    base_url = "http://localhost:8082"

WATCH_URL = f"{base_url}/watch?v={{video_id}}"
