# Bangalore Metro Journey Planner

A Flutter web application for planning journeys on the Bangalore Metro system. The app displays the metro map with Google Maps integration and provides route planning between stations.

## Features

- Interactive Google Maps with metro lines and stations
- Journey planning between any two stations
- Support for interchange stations
- Real-time route calculation
- Responsive web design

## Current Metro Lines

- **Green Line** (Operational): Madivara to Silk Institute
- **Purple Line** (Operational): Challaghatta to RV Road
- **Yellow Line** (Operational): RV Road to Electronic City
- **Blue Line** (Planned): Not yet implemented
- **Pink Line** (Planned): Not yet implemented

## Setup

1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Maps JavaScript API
   - Add your API key to `.env`:
     ```
     GOOGLE_MAPS_API_KEY=your_actual_api_key_here
     ```

4. Run the app:
   ```bash
   # For development
   flutter run -d chrome --dart-define=GOOGLE_MAPS_API_KEY=$(grep GOOGLE_MAPS_API_KEY .env | cut -d '=' -f2)
   
   # Or use the build script
   ./scripts/build.sh
   ```

## Deployment to Vercel

1. Connect your GitHub repository to Vercel
2. Add environment variable in Vercel dashboard:
   - Go to Project Settings → Environment Variables
   - Add `GOOGLE_MAPS_API_KEY` with your API key
   - Make sure it's available for all environments (Production, Preview, Development)
3. Vercel will automatically build and deploy using the configuration in `vercel.json`
4. The build script will inject the API key during deployment

## Project Structure

```
lib/
├── data/           # Metro station and line data
├── models/         # Data models
├── providers/      # State management
├── screens/        # Main screens
├── services/       # Business logic
└── widgets/        # Reusable UI components
```

## Contributing

Feel free to contribute by adding more stations, improving the route algorithm, or enhancing the UI.