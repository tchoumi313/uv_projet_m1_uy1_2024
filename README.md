# NexGen Agri

NexGen Agri is a comprehensive application designed to assist farmers with crop recommendations and plant disease detection. The application consists of a backend server for processing and a frontend mobile application for user interaction.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Backend Setup](#backend-setup)
- [Frontend Setup](#frontend-setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- Crop recommendations based on soil and weather conditions.
- Plant disease detection using image processing.
- Chatbot for user assistance.
- User authentication and data storage.

## Prerequisites

- Python 3.8+
- Flutter 2.0+
- Node.js (for Firebase CLI)
- Firebase account

## Backend Setup

1. **Clone the repository**:
   ```sh
   git clone https://github.com/yourusername/nexgen_agri.git
   cd nexgen_agri
   ```

2. **Create a virtual environment**:
   ```sh
   python -m venv env
   source env/bin/activate  # On Windows use `env\Scripts\activate`
   ```

3. **Install dependencies**:
   ```sh
   
   pip install -r requirements.txt
   ```

4. **Set up environment variables**:
  

5. **Run the backend server**:
   ```sh
   python app.py
   ```

## Frontend Setup

1. **Navigate to the frontend directory**:
   ```sh
   cd nexgen_agri
   ```

2. **Install Flutter dependencies**:
   ```sh
   flutter pub get
   ```

3. **Configure Firebase**:
   - Follow the instructions on the [Firebase website](https://firebase.google.com/docs/flutter/setup) to set up Firebase for your Flutter project.
   - Add the `google-services.json` file to the `android/app` directory.
   - Add the `GoogleService-Info.plist` file to the `ios/Runner` directory.

4. **Run the frontend application**:
   ```sh
   flutter run
   ```

## Usage

- **Dashboard**: View crop recommendations and detected plant diseases.
- **Chatbot**: Get assistance and advice on crop management.


## Contributing

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) to learn how you can help.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Code References

### Backend Code

The backend code for loading and predicting plant images is located in the `api/plant.py` file:


### Frontend Code



The frontend code for the dashboard screen is located in the `nexgen_agri/lib/main.dart` file:


Feel free to reach out if you have any questions or need further assistance!