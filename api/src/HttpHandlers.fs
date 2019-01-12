namespace api

open api.TaskStore
open api.Domain.Domain
open api.CommandHandler

module HttpHandlers =

    open Microsoft.AspNetCore.Http
    open FSharp.Control.Tasks.V2.ContextInsensitive
    open Giraffe
    open api.Models
    open api.ReadSide
    open api.Helpers
    
    let private pipeline command = 
        command 
        |> CommandHandler.handle
        |> Result.bind(ReadSide.handleEvent)

    let getAllTasks =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let resultTasks = TaskStore.loadTasks()
                
                match resultTasks with
                | Ok tasks -> let tasksDto = tasks |> Array.map(fun task -> {TaskDto.Id = task.Id; TaskDto.Name = task.Name; TaskDto.IsComplete = task.IsComplete;
                                                                             TaskDto.DueDate = Helpers.tryConvertToString task.DueDate})
                              return! json tasksDto next ctx
                | Error message -> return! json message next ctx
            }
    
    let addTask =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let! addTaskDto = ctx.BindJsonAsync<AddTaskDto>()
                let newId = System.Guid.NewGuid().ToString()
                let addTaskArgs = {CmdArgs.AddTask.Id = newId
                                   CmdArgs.AddTask.Name = addTaskDto.Name
                                   CmdArgs.AddTask.DueDate = Helpers.Helpers.tryConvertToDateTime addTaskDto.DueDate}
                let executionResult = pipeline (AddTask(addTaskArgs))
                
                match executionResult with
                | Ok _ -> ctx.SetStatusCode 201
                          return! json newId next ctx
                | Error message -> ctx.SetStatusCode 400
                                   return! json message next ctx
            }
    
    let updateTaskDueDate = 
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let! updateTaskDto = ctx.BindJsonAsync<UpdateTaskDueDateDto>()
                let updateTaskArgs = {CmdArgs.ChangeTaskDueDate.Id = updateTaskDto.Id;  CmdArgs.ChangeTaskDueDate.DueDate = Helpers.Helpers.tryConvertToDateTime updateTaskDto.DueDate}
                let executionResult = pipeline (ChangeTaskDueDate(updateTaskArgs))
                
                match executionResult with
                | Ok _ -> ctx.SetStatusCode 202
                          return! next ctx
                | Error message -> ctx.SetStatusCode 400
                                   return! json message next ctx
            }
    
    let completeTask = 
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let! updateTaskDto = ctx.BindJsonAsync<CompleteTaskDto>()
                let updateTaskArgs = {CmdArgs.CompleteTask.Id = updateTaskDto.Id; }
                let executionResult = pipeline (CompleteTask(updateTaskArgs))
                
                match executionResult with
                | Ok _ -> ctx.SetStatusCode 201
                          return! next ctx
                | Error message -> ctx.SetStatusCode 400
                                   return! json message next ctx
            }

    let removeAllTasks =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let executionResult = pipeline ClearAllTasks

                match executionResult with
                | Ok _ -> ctx.SetStatusCode 202
                          return! next ctx
                | Error message -> ctx.SetStatusCode 400
                                   return! json message next ctx
            }

    let removeTask (removeTaskDto: RemoveTaskDto) =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let removeTaskArgs = {CmdArgs.RemoveTask.Id = removeTaskDto.Id; }
                let executionResult = pipeline (RemoveTask(removeTaskArgs))
                
                match executionResult with
                | Ok _ -> ctx.SetStatusCode 201
                          return! next ctx
                | Error message -> ctx.SetStatusCode 400
                                   return! json message next ctx
            }