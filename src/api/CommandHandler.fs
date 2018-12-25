namespace api.CommandHandler

open api.Domain.Domain
open api.Aggregate.Aggregate
open api.Helpers
open api.EventStore

module CommandHandler =

    module Mapping = 
        let toDomainEvent data =
            match data.Name with
            | "TaskAdded"-> TaskAdded {Id = data.Data.Id; Name = data.Data.Name; DueDate = (Helpers.tryConvertToDateTime data.Data.DueDate) }
            | "TaskRemoved" -> TaskRemoved {Id = data.Data.Id; }
            | "AllTasksCleared" -> TaskCleared 
            | "TaskCompleted" -> TaskCompleted {Id = data.Data.Id; }
            | "TaskDueDateChanged" -> TaskDueDateChanged {Id = data.Data.Id; DueDate = (Helpers.tryConvertToDateTime data.Data.DueDate)}
            | _ -> failwith "Unknown event name"
        
        let toStoreEvent data =
            match data with
            | TaskAdded args -> {Name = args.Name; Data = {Id = args.Id; Name = args.Name; DueDate =  if args.DueDate.IsSome then args.DueDate.ToString() else "" }}
            | TaskRemoved args -> {Name = "TaskRemoved"; Data = {Id = args.Id; Name = "TaskRemoved"; DueDate = "" } }
            | TaskCleared -> { Name = "TaskCleared"; Data = {Id =  0; Name = "TaskClared"; DueDate =  "" }} 
            | TaskCompleted args -> {Name = "TaskCompleted"; Data = {Id = args.Id; Name = "TaskCompleted"; DueDate = "" }} 
            | TaskDueDateChanged args -> {Name = "TaskDueDateChanged"; Data = {Id = args.Id; Name = "TaskDueDateChanged"; DueDate =  if args.DueDate.IsSome then args.DueDate.ToString() else "" }} 
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
    let getCurrentState () = 
        EventStore.loadEvents()
        |> Array.map(Mapping.toDomainEvent)
        |> Array.fold taskAggregate.Apply taskAggregate.Init

    let append (events:Event []) = 
        events
        |> Array.map(Mapping.toStoreEvent)
        |> EventStore.saveEvents
        |> ignore