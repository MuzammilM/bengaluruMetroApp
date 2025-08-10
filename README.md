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

3. Get a Google Maps API key:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Maps JavaScript API
   - Create an API key
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` in `web/index.html`

4. Run the app:
   ```bash
   flutter run -d chrome
   ```

## Deployment to Vercel

1. Connect your GitHub repository to Vercel
2. Vercel will automatically detect the Flutter project
3. The app will be built and deployed using the configuration in `vercel.json`

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