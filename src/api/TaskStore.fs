namespace api.TaskStore

open System.IO
open api.Domain.Domain
open Newtonsoft.Json

module TaskStore = 
    let loadTasks() =
        try
            File.ReadAllText "task.json"
            |> JsonConvert.DeserializeObject<Task[]>
            |> Ok
        with
        | ex -> Error(ex.Message)
    
    let loadTaskById id = 
        try
           loadTasks()
           |> Result.bind(fun tasks -> tasks 
                                       |> Array.find(fun task -> task.Id = id)
                                       |> Ok)
        with
        | ex -> Error(ex.Message)

    let saveTask (task:Task) =
        loadTasks()
        |> Result.bind(fun storedTasks -> storedTasks
                                          |>Array.append [|task|] 
                                          |> JsonConvert.SerializeObject
                                          |> fun tasksJson -> File.WriteAllText("task.json", tasksJson)
                                          |> fun _ -> Ok())

    let updateTask id (updatedTask:Task)= 
        loadTasks()
        |> Result.bind(fun tasks -> tasks 
                                    |> Array.filter(fun storedTask -> storedTask.Id <> id)
                                    |> Array.append [|updatedTask|]
                                    |> JsonConvert.SerializeObject
                                    |> fun tasksJson -> File.WriteAllText("task.json", tasksJson)
                                    |> fun _ -> Ok())

    let removeAllTasks () =
        try
            File.WriteAllText("task.json", "[]")
            Ok()
        with
        | ex -> Error(ex.Message)

    let removeTask id =
        loadTasks()
        |> Result.bind(fun tasks -> tasks 
                                    |> Array.filter(fun storedTask -> storedTask.Id <> id)
                                    |> JsonConvert.SerializeObject
                                    |> fun tasksJson -> File.WriteAllText("task.json", tasksJson)
                                    |> fun _ -> Ok())