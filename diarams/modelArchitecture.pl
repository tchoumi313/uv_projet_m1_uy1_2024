@startuml
skinparam componentStyle rectangle

package "Machine Learning Models" {
    [Crop Recommendation (Random Forest)]
    [Plant Disease Detection (CNN)]
}

package "Features" {
    [N Content]
    [P Content]
    [K Content]
    [Temperature]
    [Humidity]
    [pH Value]
    [Rainfall]
    [Plant Image]
}

package "Processes" {
    [Data Preprocessing]
    [Model Training]
    [Prediction]
    [Evaluation]
}

[Crop Recommendation (Random Forest)] --> [N Content]
[Crop Recommendation (Random Forest)] --> [P Content]
[Crop Recommendation (Random Forest)] --> [K Content]
[Crop Recommendation (Random Forest)] --> [Temperature]
[Crop Recommendation (Random Forest)] --> [Humidity]
[Crop Recommendation (Random Forest)] --> [pH Value]
[Crop Recommendation (Random Forest)] --> [Rainfall]

[Plant Disease Detection (CNN)] --> [Plant Image]

[Data Preprocessing] --> [Crop Recommendation (Random Forest)]
[Data Preprocessing] --> [Plant Disease Detection (CNN)]
[Model Training] --> [Crop Recommendation (Random Forest)]
[Model Training] --> [Plant Disease Detection (CNN)]
[Prediction] --> [Crop Recommendation (Random Forest)]
[Prediction] --> [Plant Disease Detection (CNN)]
[Evaluation] --> [Crop Recommendation (Random Forest)]
[Evaluation] --> [Plant Disease Detection (CNN)]
@enduml
