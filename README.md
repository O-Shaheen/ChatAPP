# README

## Requirements
1. Docker
2. Docker-compose 

## Stack
1. MySQL
2. Sidekiq for queuing and executing jobs
3. Redis
4. Redlock for handling redis mutex locks
5. Elasticsearch for searching for a message

## How to run
- clone the repo
- run docker-compose build
- `docker-compose build --no-cache`
- run docker-compose up
- `docker-compose up`

## API documentation
The API controllers are located in `ChatAPP/app/controllers`

### 1. Applications
Get All Applications 
```
curl --location 'http://localhost:3000/applications' 
```
Create a New Application
``` 
curl --location 'http://localhost:3000/applications' \
--header 'Content-Type: application/json' \
--data '{
    "name":"application name"
}' 
```
Update an Application
``` 
curl --location --request PUT 'http://localhost:3000/applications/:token' \
--header 'Content-Type: application/json' \
--data '{
    "name":"new application name"
}'
```
Delete an Application
``` 
curl --location --request DELETE 'http://localhost:3000/applications/:token' 
```

### 2. Chats
Get All Chats
``` 
curl --location 'http://localhost:3000/applications/:token/chats' 
```
Create a New Chat
```
curl --location 'http://localhost:3000/applications/:token/chats' \
--header 'Content-Type: application/json' \
--data '{
    "name":"chat name"
}'
```
Update a Chat
```
curl --location --request PUT 'http://localhost:3000/applications/:token/chats/:chat_number' \
--header 'Content-Type: application/json' \
--data '{
    "name":"new chat name"
}'
```
Delete a Chat
``` 
curl --location --request DELETE 'http://localhost:3000/applications/:token/chats/:chat_number' 
```

### 3. Messages

Get All Messages
``` 
curl --location 'http://localhost:3000/applications/:token/chats/:chat_number/messages' 
```
Create a New Message
```
curl --location 'http://localhost:3000/applications/:token/chats/:chat_number/messages' \
--header 'Content-Type: application/json' \
--data '{
    "body":"message content"
}'
```
Update a Message
```
curl --location --request PUT 'http://localhost:3000/applications/:token/chats/:chat_number/messages/:message_number' \
--header 'Content-Type: application/json' \
--data '{
    "body":"new message content"
}'
```
Delete a Message
```
curl --location --request DELETE 'http://localhost:3000/applications/:token/chats/:chat_number/messages/:message_number'
```

### 4. Find messages
```
curl --location 'http://localhost:3000/applications/:token/chats/:chat_number/messages/search?query=message_body'
```

## ER diagram
The schema path is `ChatAPP/db/schema.rb`
![Database ER diagram (crow's foot)](https://github.com/user-attachments/assets/9ffc8e3d-e3e6-4e2b-8d51-598ed6c3cc89)

## Workers
The workers are located in `ChatAPP/app/sidekiq`

## Data Storage
MySQL: Used for long-term, persistent data storage. To prevent race conditions, locks are applied during updates, which can increase request latency. To improve performance, I also created indexing on key columns to enhance search.

Redis: Used for short-term, temporary storage due to its in-memory nature. It acts as a datastore for Sidekiq jobs (message queue) until they are executed, minimizing request latency. Redis is also used to track the next available numbers for chats and message creation.

# ChatAPP
