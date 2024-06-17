import unittest

from app import app  # Import your Flask app
from flask_testing import TestCase


class TestFlaskApi(TestCase):
    def create_app(self):
        app.config['TESTING'] = True
        return app

    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        print('Home endpoint response:', response.data.decode())

    def test_weather(self):
        response = self.client.get('/weather?lat=33.44&lon=-94.04')
        self.assertEqual(response.status_code, 200)
        print('Weather endpoint response:', response.data.decode())

    def test_forecast(self):
        response = self.client.get('/forecast?lat=33.44&lon=-94.04')
        self.assertEqual(response.status_code, 200)
        print('Forecast endpoint response:', response.data.decode())

    def test_predict_crop(self):
        # Assuming predict_crop expects POST with JSON data
        data = {
            'nitrogen': 10,
            'phosphorus': 10,
            'potassium': 10,
            'temperature': 25,
            'humidity': 50,
            'ph': 6.5,
            'rainfall': 200
        }
        response = self.client.post('/predictCrop', json=data)
        self.assertEqual(response.status_code, 200)
        print('Predict crop endpoint response:', response.data.decode())

    def test_check_disease(self):
        # Assuming checkDisease expects POST with JSON data
        data = {'link': 'https://randompicturegenerator.com/img/flower-generator/g30ba8d335f46eac468764c2b81cb448d1a14e77bc16db6df1114de507292452f88e140ba57471ffe6b9cc1695dbde5a8_640.jpg'}
        response = self.client.post('/checkDisease', json=data)
        self.assertEqual(response.status_code, 200)
        print('Check disease endpoint response:', response.data.decode())

    def test_completion_endpoint(self):
        # Sample prompt for testing
        data = {'prompt': 'How can I improve my crop yield?'}

        # Send a POST request to the completion endpoint
        response = self.client.post('/chat_completion', json=data)

        # Assert the response status code
        self.assertEqual(response.status_code, 200)

        # Assert the response content
        response_data = response.get_json()
        self.assertIn('response', response_data)
        self.assertIsInstance(response_data['response'], str)
        self.assertNotEqual(response_data['response'], '')  # Ensure the response is not empty

        print('Chat completion endpoint response:', response_data['response'])


if __name__ == '__main__':
    unittest.main()