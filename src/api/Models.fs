namespace api.Models

[<CLIMutable>]
type AddTaskDto = {
    Name : string
    DueDate: string
}

[<CLIMutable>]
type UpdateTaskDueDateDto = {
    Id : string
    DueDate: string
}

[<CLIMutable>]
type CompleteTaskDto = {
    Id : string
}

[<CLIMutable>]
type RemoveTaskDto = {
    Id : string
}

[<CLIMutable>]
type TaskDto = {
    Id: string
    Name: string
    DueDate: string
    IsComplete: bool
}