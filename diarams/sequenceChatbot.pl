@startuml
actor User
participant Flutter
participant NexGen_AgriChatbot
participant NaturalLanguageProcessing as NLP
participant ResponseGenerator as RG
participant KnowledgeBase as KB
participant Database

User ->> Flutter : Request message
Flutter ->> NexGen_AgriChatbot : Send message
NexGen_AgriChatbot ->> NLP : Process message
NLP -->> NexGen_AgriChatbot : Parsed message
NexGen_AgriChatbot ->> RG : Generate response
RG ->> KB : Query knowledge base
KB -->> RG : Retrieve relevant information
RG -->> NexGen_AgriChatbot : Construct response
NexGen_AgriChatbot -->> Flutter : Send response
Flutter -->> Database : save chat messages(request,response)
Flutter -->> User : Display Response
@enduml
