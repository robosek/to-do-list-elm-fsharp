namespace api.Aggregate

open api.Domain.Domain
open api.Helpers

module Aggregate = 
    let onlyIfTaskDoesntAlreadyExist (state:State) id =
        match Helpers.maybeTask state id with
        | Some _ -> failwith "Task already exists"
        | None -> state

    let onlyIfTaskExists (state:State) id = 
        match Helpers.maybeTask state id with
        | Some task -> task
        | None -> failwith "There are no task with provided id"

    let onlyIfNotAlreadyFinished (task:Task) = 
        match task.IsComplete with
        | true -> failwith "Task is already finished"
        | false -> task

    let execute state command = 
        let event = 
            match command with 
            | AddTask args -> args.Id
                              |> onlyIfTaskDoesntAlreadyExist state
                              |> (fun _ -> TaskAdded args)
            | RemoveTask args -> args.Id
                                 |> onlyIfTaskExists state
                                 |> (fun _ -> TaskRemoved args)
            | ClearAllTasks -> TaskCleared
            | CompleteTask args -> args.Id
                                   |> onlyIfTaskExists state
                                   |> (fun _ -> TaskCompleted args)
            | ChangeTaskDueDate args -> args.Id
                                        |> (onlyIfTaskExists state >> onlyIfNotAlreadyFinished)
                                        |> (fun _ -> TaskDueDateChanged args)
        event |> List.singleton

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
        Execute: 'state -> 'command -> 'event list 
    }

    let taskAggregate = {
        Init = State.Init
        Apply = apply
        Execute = execute
    }