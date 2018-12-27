namespace api.Helpers

open api.Domain.Domain
open System

module Helpers = 
    let maybeTaskById (state:State) id =
        state.Tasks |> List.tryFind(fun task -> task.Id = id)
        
    let maybeTaskByName (state:State) name =
        state.Tasks |> List.tryFind(fun task -> task.Name = name)

    let tryConvertToDateTime (dateTimeText:string) =
        try 
            Some(Convert.ToDateTime(dateTimeText))
        with
        | _ -> None
    
    let tryConvertToString (dateTime:DateTime option) =
       match dateTime with
       | Some date -> date.ToShortDateString()
       | None -> ""