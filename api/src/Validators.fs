namespace api.Validators

open System
open api.Domain.Domain
open api.Domain.Domain.CmdArgs

module Validators = 
    let private validateAddTask (addTask: AddTask) =
        match addTask.DueDate with 
        | Some date -> if String.IsNullOrEmpty addTask.Name then
                            Error "You have to specify task name"
                       elif date.Date < DateTime.Now.Date then
                            Error "Task due date can not be earlier then now"
                       else
                            Ok (AddTask(addTask))
        | None -> Error "You have to specify due date"
     
    let private validateChangeTaskDueDate (change: ChangeTaskDueDate) = 
          match change.DueDate with
          | Some date -> if date.Date < DateTime.Now.Date then Error "Task due date can not be earlier then now" else Ok (ChangeTaskDueDate(change))
          | None -> Error "You have to specify due date"
    
    let validate command = 
          match command with
          | AddTask addTask -> validateAddTask addTask
          | ChangeTaskDueDate newDueDate -> validateChangeTaskDueDate newDueDate 
          | _ -> Ok command