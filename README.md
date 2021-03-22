# Application Based Chat System

## Features

- Create different chatting applications.
- For each app, you can instantiate different chats.
- For a given chat in an application, you can send messages.
- Partial search through the application chat messages.

## Tech

- **Ruby on Rails** for the server-side application.
- **Redis** used as a database cache (in-memory store).
- **Sidekiq** for job scheduling.
- **MySQL** as the database server.
- **Elasticsearch** as a search engine.
- **Docker** set of platforms as a service (container engine).

## Installation

- Install [docker](https://docs.docker.com/engine/install/).
- Download project src.

## Docker

Using CLI:

`$ cd {PROJECT_DIR_PATH}`

`$ docker-compose up`

> **_NOTE:_** Wait till all the containers are up and running. You should see something like the following:
> ...
> MySQL is up and running!
> ElasticSearch is up and running!
> ...

## APIs

[Postman Collection](https://drive.google.com/file/d/1taNKHYXuhhffqbf5OftaWNOuc92epc4t/view?usp=sharing)
