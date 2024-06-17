@startuml
actor User
participant Flutter
participant Firebase
participant Flask_API
participant CNN_Model
Participant Database

User ->> Flutter : Upload image
Flutter ->> Firebase : Send image
Firebase ->> Flask_API : Transmit image
Flask_API ->> CNN_Model : Analyze image
CNN_Model -->> Flask_API : Diagnosis result
Flask_API -->> Firebase : Send result
Firebase -->> Flutter : Transmit result
Flutter -->> Database : Save Result
Flutter -->> User : Display diagnosis
@enduml
