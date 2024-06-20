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
        data = {'link': "https://firebasestorage.googleapis.com/v0/b/nexgen-agri.appspot.com/o/c1a8c03b-1881-4a07-92fa-e195d594db46%2FIMG_20240531_104815.jpg?alt=media&token=0025bb31-f589-4c17-946c-c68fb806bbc0"}#'https://storage.googleapis.com/kagglesdsdata/datasets/78313/182633/New%20Plant%20Diseases%20Dataset%28Augmented%29/New%20Plant%20Diseases%20Dataset%28Augmented%29/train/Apple___Apple_scab/0208f4eb-45a4-4399-904e-989ac2c6257c___FREC_Scab%203037_new30degFlipLR.JPG?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=databundle-worker-v2%40kaggle-161607.iam.gserviceaccount.com%2F20240618%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20240618T174026Z&X-Goog-Expires=345600&X-Goog-SignedHeaders=host&X-Goog-Signature=19d68dbe39dd017d189340efbacf52974c30b044d9c5844b9b9a022acbb4a9e989905c7277b7ab43dd11b6f244067b38489a4043029d343085eceb0149e7541c0db0073bf8deddc14a6e52d1a645de5e1a2f0d7278c776e046f05009ee0744cf8f18e078eb80e6b5bd47edbc34055e8b5125d7a5e6773f8bcddf1e7a1d9b6858b469f581976783d06f187d72e7f575f2e82072a71e4828949132420a70b192dd5250ce58ba4e40d0ba44de6ec6eea7c56970533b86ff910de68a53c997f993238d06c1adc04db6e1943fed86b7644669a663d0590dfb6d131e50c8d90cadbea8c23469be2ea40e172676b4cf23423f0fb82ab8fef112ae4edf7bc1e4aeeefbf6'}
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