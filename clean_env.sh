#!/bin/bash

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env file not found!"
  exit 1
fi

# Create a backup of the original .env file
cp "$ENV_FILE" "${ENV_FILE}.bak"

# Replace API keys with placeholders
sed -i '' 's/^GOOGLE_MAPS_API_KEY=.*/GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here/' "$ENV_FILE"
sed -i '' 's/^OPENWEATHER_API_KEY=.*/OPENWEATHER_API_KEY=your_openweather_api_key_here/' "$ENV_FILE"
sed -i '' 's/^OPENAI_API_KEY=.*/OPENAI_API_KEY=your_openai_api_key_here/' "$ENV_FILE"
sed -i '' 's/^API_BASE_URL=.*/API_BASE_URL=your_api_base_url_here/' "$ENV_FILE"
sed -i '' 's/^ENCRYPTION_SECRET=.*/ENCRYPTION_SECRET=your_encryption_secret_here/' "$ENV_FILE"
sed -i '' 's/^SUPABASE_URL=.*/SUPABASE_URL=your_supabase_url_here/' "$ENV_FILE"
sed -i '' 's/^SUPABASE_ANON_KEY=.*/SUPABASE_ANON_KEY=your_supabase_anon_key_here/' "$ENV_FILE"

echo "API keys have been replaced with placeholders. Original .env saved as .env.bak" 