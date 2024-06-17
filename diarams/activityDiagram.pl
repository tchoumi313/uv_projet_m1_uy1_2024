@startuml
start
:User inputs parameters;
:Send parameters to backend;
:Backend processes parameters;
:Query Crop Recommendation Model;
if (Model suggests a crop?) then (yes)
  :Return recommended crop;
else (no)
  :Handle no recommendation case;
endif
:Display recommendation to user;
stop
@enduml
