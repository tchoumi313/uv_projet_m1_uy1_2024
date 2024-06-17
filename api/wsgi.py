from app import app

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))  # Get the PORT environment variable or default to 5000
    app.run(port=port)