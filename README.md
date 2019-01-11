## Elm + F# Giraffe

### Frontend: Elm
Tasks list implementation using Elm

### Backend: CQRS nad Event Sourcing implementation in F# with Giraffe
TODO API with endpoints:
- `POST` new Task
- `DELETE` all Tasks
- `DELETE` task by id
- `PUT` - update task due date
- `PUT` - set task as completed
- `GET` - all tasks

### Run application
The easiest way to launch this application is by using Docker compose.
In main directory just run this command.
```
docker-compose -f docker-compose.yml up --build
```