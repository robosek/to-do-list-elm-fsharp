namespace api.Helpers

open api.Domain.Domain
open System

module Helpers = 
    let maybeTask (state:State) id =
        state.Tasks |> List.tryFind(fun task -> task.Id = id)

    let tryConvertToDateTime (dateTimeText:string) =
        try 
            Some(Convert.ToDateTime(dateTimeText))
        with
        | _ -> None