namespace api.Domain

open System

module Domain =

    module CmdArgs =

        type AddTask = {
            Id: string
            Name: string
            DueDate: DateTime option
        }

        type RemoveTask = {
            Id: string
        }

        type CompleteTask = {
            Id: string
        }

        type ChangeTaskDueDate = {
            Id: string
            DueDate: DateTime option
        }

    type Command =
        | AddTask of CmdArgs.AddTask
        | RemoveTask of CmdArgs.RemoveTask
        | ClearAllTasks
        | CompleteTask of CmdArgs.CompleteTask
        | ChangeTaskDueDate of CmdArgs.ChangeTaskDueDate

    type Event = 
        | TaskAdded of CmdArgs.AddTask
        | TaskRemoved of CmdArgs.RemoveTask
        | TaskCleared 
        | TaskCompleted of CmdArgs.CompleteTask
        | TaskDueDateChanged of CmdArgs.ChangeTaskDueDate

    type Task = {
        Id: string
        Name: string
        DueDate: DateTime option
        IsComplete: bool
    }

    type State = {
        Tasks : Task list
    } with static member Init = {Tasks = []}

    type Argument = {
        Id: string
        Name: string
        DueDate: string
    }
    type StoreEvent = {
       Name: string
       OperationDate: string
       Data: Argument
    }