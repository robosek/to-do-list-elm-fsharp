namespace api.Aggregate

open api.Domain.Domain
open api.Helpers

module Aggregate = 
    let onlyIfTaskDoesntAlreadyExist (state:State) name =
        match Helpers.maybeTaskByName state name with
        | Some _ -> Error("Task already exists")
        | None -> Ok state

    let onlyIfTaskExists (state:State) id = 
        match Helpers.maybeTaskById state id with
        | Some task -> Ok task
        | None -> Error("There are no task with provided id")

    let onlyIfNotAlreadyFinished (resultTask:Result<Task,string>) =
        resultTask 
        |> Result.bind(fun task ->  match task.IsComplete with
                                    | false -> Ok(task)
                                    | true -> Error("Task not finished"))


    let execute state command = 
        match command with 
        | AddTask args -> args.Name
                          |> onlyIfTaskDoesntAlreadyExist state
                          |> Result.bind(fun _ -> Ok(TaskAdded args))
        | RemoveTask args -> args.Id
                             |> onlyIfTaskExists state
                             |> Result.bind(fun _ -> Ok(TaskRemoved args)) 
        | ClearAllTasks -> Ok TaskCleared
        | CompleteTask args -> args.Id
                               |> onlyIfTaskExists state
                               |> Result.bind(fun _ -> Ok(TaskCompleted args)) 
        | ChangeTaskDueDate args -> args.Id
                                    |> (onlyIfTaskExists state >> onlyIfNotAlreadyFinished)
                                    |> Result.bind(fun _ -> Ok(TaskDueDateChanged args))

    let apply state event =
        match event with
        | TaskAdded args -> 
            let newTask = { Id = args.Id
                            Name = args.Name
                            DueDate = args.DueDate
                            IsComplete = false }

            {state with Tasks = newTask::state.Tasks}
        
        | TaskRemoved args -> 
            {state with Tasks = (state.Tasks |> List.filter(fun task -> task.Id <> args.Id))}
        
        | TaskCleared -> {state with Tasks = []}

        | TaskCompleted args -> let task = state.Tasks |> List.find(fun task -> task.Id = args.Id)
                                                       |> fun task -> {task with IsComplete = true}
                                let otherTasks = state.Tasks |> List.filter(fun task -> task.Id <> args.Id)
                                { state with Tasks = task :: otherTasks }

        | TaskDueDateChanged args -> let task = state.Tasks |> List.find(fun task -> task.Id = args.Id)
                                                            |> fun task -> {task with DueDate = args.DueDate}
                                     let otherTasks = state.Tasks |> List.filter(fun task -> task.Id <> args.Id)
                                     { state with Tasks = task :: otherTasks }

    type Aggregate<'state,'command,'event> = {
        Init: 'state
        Apply: 'state -> 'event -> 'state
        Execute: 'state -> 'command -> Result<'event,string> 
    }

    let taskAggregate = {
        Init = State.Init
        Apply = apply
        Execute = execute
    }