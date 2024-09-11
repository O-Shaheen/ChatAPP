# README

## [API documentation](https://documenter.getpostman.com/view/14288754/2sAXqmBkDV)

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

## ER diagram
![Database ER diagram (crow's foot)](https://github.com/user-attachments/assets/9ffc8e3d-e3e6-4e2b-8d51-598ed6c3cc89)


## Data Storage
MySQL: Used for long-term, persistent data storage. To prevent race conditions, locks are applied during updates, which can increase request latency. To improve performance, I also created indexing on key columns to enhance search.

Redis: Used for short-term, temporary storage due to its in-memory nature. It acts as a datastore for Sidekiq jobs (message queue) until they are executed, minimizing request latency. Redis is also used to track the next available numbers for chats and message creation.

# ChatAPP
