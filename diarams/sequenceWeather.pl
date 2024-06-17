@startuml
actor System
participant Flutter
participant Firebase
participant Weather_API

System ->> Flutter : Request weather data
Flutter ->> Firebase : Forward request
Firebase ->> Weather_API : Fetch weather data
Weather_API -->> Firebase : Send weather data
Firebase -->> Flutter : Transmit weather data
Flutter -->> System : Display weather data
@enduml
