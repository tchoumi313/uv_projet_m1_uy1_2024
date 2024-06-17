@startuml
actor User
participant Flutter
participant Firebase
participant Flask_API
participant Python_Model
participant Database

User ->> Flutter : Enter parameters
Flutter ->> Firebase : Send parameters
Firebase ->> Flask_API : Transmit parameters
Flask_API ->> Python_Model : Predict based on parameters
Python_Model -->> Flask_API : Prediction results
Flask_API -->> Firebase : Send results
Firebase -->> Flutter : Transmit results
Flutter -->> Database : Save Result
Flutter -->> User : Display recommendations
@enduml
