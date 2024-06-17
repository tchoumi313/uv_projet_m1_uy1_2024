classDiagram
@startuml
    class Utilisateur {
        -String nom
        -String email
        -String motDePasse
        +sInscrire()
        +seConnecter()
    }
    class Recommandation {
        -float N
        -float P
        -float K
        -float temperature
        -float humidity
        -float ph
        -float rainfall
        -String recommendation
        +faireRecommandation()
    }
    class DiseaseDetection {
        -String imagePath
        -bool isHealthy
        -String diseaseName
        -String description
        -String solution
        -String vegetable
        +detecterMaladie()
    }
    class ChatHistory{
        -String role
        -String content
    }
    class Weather {
        -String ville
        -String temperature
        -String conditions
        -String humidity
        -String windSpeed
        -String precipitation
        -String visibility
        -String uvIndex
        -String airQuality
        +afficherConditions()
    }
    class System{
        +getCurrentWeather()
        +getForecastData()
    }

    Utilisateur "1" --> "1..n" Recommandation
    Utilisateur "1" --> "1..n" DiseaseDetection
    Utilisateur "1" --> "1..n" Weather
    Utilisateur "0..n" --> "0..n" ChatHistory
    System "0..n" --> "0..n" ChatHistory
@enduml