#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Build Flutter web
flutter build web --release --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY

# Replace placeholder in index.html with actual API key
if [ ! -z "$GOOGLE_MAPS_API_KEY" ]; then
    sed -i.bak "s/{{GOOGLE_MAPS_API_KEY}}/$GOOGLE_MAPS_API_KEY/g" build/web/index.html
    rm build/web/index.html.bak
    echo "✅ API key injected successfully"
else
    echo "❌ GOOGLE_MAPS_API_KEY not found in environment"
    exit 1
fi