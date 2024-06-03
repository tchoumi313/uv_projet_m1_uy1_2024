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
        data = {'image_url': 'http://example.com/image.jpg'}
        response = self.client.post('/checkDisease', json=data)
        self.assertEqual(response.status_code, 200)
        print('Check disease endpoint response:', response.data.decode())

if __name__ == '__main__':
    unittest.main()