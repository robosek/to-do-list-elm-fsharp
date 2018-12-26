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
            | "TaskCleared" -> TaskCleared 
            | "TaskCompleted" -> TaskCompleted {Id = data.Data.Id; }
            | "TaskDueDateChanged" -> TaskDueDateChanged {Id = data.Data.Id; DueDate = (Helpers.tryConvertToDateTime data.Data.DueDate)}
            | _ -> failwith "Unknown event name"
        
        let toStoreEvent data =
            match data with
            | TaskAdded args -> {Name = "TaskAdded"; Data = {Id = args.Id; Name = args.Name; DueDate =  if args.DueDate.IsSome then args.DueDate.ToString() else "" }}
            | TaskRemoved args -> {Name = "TaskRemoved"; Data = {Id = args.Id; Name = ""; DueDate = "" } }
            | TaskCleared -> { Name = "TaskCleared"; Data = {Id = ""; Name = ""; DueDate =  "" }} 
            | TaskCompleted args -> {Name = "TaskCompleted"; Data = {Id = args.Id; Name = ""; DueDate = "" }} 
            | TaskDueDateChanged args -> {Name = "TaskDueDateChanged"; Data = {Id = args.Id; Name = ""; DueDate =  if args.DueDate.IsSome then args.DueDate.ToString() else "" }}

    let getCurrentState () = 
        EventStore.loadEvents()
        |> Array.map(Mapping.toDomainEvent)
        |> Array.fold taskAggregate.Apply taskAggregate.Init

    let append (events:Event []) = 
        events
        |> Array.map(Mapping.toStoreEvent)
        |> EventStore.saveEvents
        |> ignore
    
    let handleCommand command = 
        let currentState = getCurrentState()
        command 
        |> taskAggregate.Execute currentState
        |> Result.bind(fun event -> append [|event|]
                                    Ok(event))