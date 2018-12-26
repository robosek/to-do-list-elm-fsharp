namespace api.EventStore

open System.IO
open api.Domain.Domain
open Newtonsoft.Json

module EventStore = 
    let loadEvents() =
        File.ReadAllText "events.json"
        |> JsonConvert.DeserializeObject<StoreEvent[]>
        |> Array.sortBy(fun task -> task.Data.DueDate)

    let saveEvents (events:StoreEvent[]) =
        loadEvents()
        |> fun storedEvents -> [|events; storedEvents|] |> Array.concat
        |> JsonConvert.SerializeObject
        |> fun eventsJson -> File.WriteAllText("events.json", eventsJson)