@startuml
left to right direction
actor "User" as user
rectangle System {
  usecase "Login" as UC1
  usecase "Signup" as UC2
  usecase "Launch a recommendation" as UC3
  usecase "Detect leaf Disease" as UC4
  usecase "Get Weather conditions" as UC5
   usecase "Chat with our Specialise in Agriculture chatbot" as UC6
}
user -- UC1
user -- UC2
user -- UC3
user -- UC4
user -- UC5
user -- UC6
@enduml