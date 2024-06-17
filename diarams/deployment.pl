@startuml
node "User Device" {
    [Flutter App]

}

node "Render Cloud" {
    node "Firebase" {
        [Authentication]

    }
    node "Database"{
     [SQFLITE]
     }

    node "Flask API Server" {
        [API Controllers]
        [Business Logic]
        [Data Access Layer]
    }

    node "Machine Learning Server" {
        [Crop Recommendation (Random Forest)]
        [Plant Disease Detection (CNN)]
    }
}

[Flutter App] --> [Authentication] : Authenticates
[Flutter App] --> [SQFLITE] : Stores/Retrieves Data
[Flutter App] --> [API Controllers] : Sends Requests
[API Controllers] --> [Business Logic] : Processes
[Business Logic] --> [Data Access Layer] : Interacts
[Data Access Layer] --> [SQFLITE] : CRUD Operations
[Business Logic] --> [Crop Recommendation (Random Forest)] : Calls
[Business Logic] --> [Plant Disease Detection (CNN)] : Calls
@enduml
