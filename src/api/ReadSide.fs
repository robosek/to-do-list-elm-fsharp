namespace api.ReadSide

open api.CommandHandler
open api.Domain.Domain

module ReadSide = 
    let handleCommand command = 
        let currentState = CommandHandler.getCurrentState()
        let newEvents = command |> CommandHandler.taskAggregate.Execute currentState
        newEvents |> Array.ofList |> CommandHandler.append
        newEvents

    let handleEventToConsole event = 
        match event with
        | TaskAdded args -> printfn "New task added: %s" args.Name
        | TaskCompleted args -> printfn "Task completed: %i" args.Id
        | TaskCleared -> printfn "All task removed"
        | _ -> ()

    let handleEvent event =
        event |> handleEventToConsole