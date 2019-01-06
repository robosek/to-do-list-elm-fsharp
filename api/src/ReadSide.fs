namespace api.ReadSide

open api.CommandHandler
open api.Domain.Domain
open api.TaskStore
open api.Aggregate

module ReadSide = 
    let handleEventToConsole event = 
        match event with
        | TaskAdded args -> printfn "New task added: %s" args.Name
        | TaskCompleted args -> printfn "Task completed: %s" args.Id
        | TaskCleared -> printfn "All task removed"
        | TaskDueDateChanged args -> printfn "Task due date changed. Task Id %s" args.Id 
        | TaskRemoved args -> printfn "Task removed. Task Id %s" args.Id
    
    let handleEventToTaskStore event = 
        match event with
        | TaskAdded args -> TaskStore.saveTask {Id = args.Id; Name = args.Name; DueDate = args.DueDate; IsComplete = false}
        | TaskCompleted args -> TaskStore.loadTaskById args.Id
                                |> Result.bind(fun task -> {task with IsComplete = true } |> TaskStore.updateTask args.Id)
        | TaskCleared -> TaskStore.removeAllTasks()
        | TaskDueDateChanged args -> TaskStore.loadTaskById args.Id
                                     |> Result.bind(fun task -> {task with DueDate = args.DueDate } |> TaskStore.updateTask args.Id)
        | TaskRemoved args -> TaskStore.removeTask args.Id

    let handleEvent (event:Event) =
        event |> handleEventToConsole
        event |> handleEventToTaskStore