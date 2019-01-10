namespace api.TaskStore

open System.IO
open api.Domain.Domain
open Newtonsoft.Json

module TaskStore =
    
    [<Literal>]
    let TasksFileName:string = "task.json"

    let initialize () = 
        match File.Exists(TasksFileName) with
        | true -> ()
        | false -> File.AppendAllText(TasksFileName, "[]")
                    

    let loadTasks() =
        try
            File.ReadAllText TasksFileName
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
                                          |> fun tasksJson -> File.WriteAllText(TasksFileName, tasksJson)
                                          |> fun _ -> Ok())

    let updateTask id (updatedTask:Task)= 
        loadTasks()
        |> Result.bind(fun tasks -> tasks 
                                    |> Array.filter(fun storedTask -> storedTask.Id <> id)
                                    |> Array.append [|updatedTask|]
                                    |> JsonConvert.SerializeObject
                                    |> fun tasksJson -> File.WriteAllText(TasksFileName, tasksJson)
                                    |> fun _ -> Ok())

    let removeAllTasks () =
        try
            File.WriteAllText(TasksFileName, "[]")
            Ok()
        with
        | ex -> Error(ex.Message)

    let removeTask id =
        loadTasks()
        |> Result.bind(fun tasks -> tasks 
                                    |> Array.filter(fun storedTask -> storedTask.Id <> id)
                                    |> JsonConvert.SerializeObject
                                    |> fun tasksJson -> File.WriteAllText(TasksFileName, tasksJson)
                                    |> fun _ -> Ok())