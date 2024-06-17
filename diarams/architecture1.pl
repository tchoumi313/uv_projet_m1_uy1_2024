@startuml
skinparam componentStyle rectangle

package "Flutter" {
    [UI Components]
    [Services]
}

package "Firebase" {
    [Authentication]
}
package "Database"{
    [SQFLITE]
}

package "Backend (Flask API)" {
    [API Controllers]
    [Business Logic]
    [Data Access Layer]
}

package "Machine Learning" {
    [Crop Recommendation]
    [Plant Disease Detection]
}

[UI Components] --> [Services] : Uses
[Services] --> [Authentication] : Authenticates
[Services] --> [SQFLITE] : Stores/Retrieves Data
[Services] --> [API Controllers] : Sends Requests
[API Controllers] --> [Business Logic] : Processes
[Business Logic] --> [Data Access Layer] : Interacts
[Data Access Layer] --> [SQFLITE] : CRUD Operations
[Business Logic] --> [Crop Recommendation] : Calls
[Business Logic] --> [Plant Disease Detection] : Calls
@enduml
