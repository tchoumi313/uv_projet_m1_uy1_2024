@startuml
[*] --> LoggedOut
LoggedOut --> LoggingIn : User submits credentials
LoggingIn --> LoggedIn : Authentication successful
LoggingIn --> LoggedOut : Authentication failed
LoggedIn --> LoggingOut : User logs out
LoggingOut --> LoggedOut
LoggedIn --> SessionExpired : Inactivity timeout
SessionExpired --> LoggedOut
@enduml
