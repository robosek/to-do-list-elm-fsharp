namespace api.EventStore

open System.IO
open api.Domain.Domain
open Newtonsoft.Json

module EventStore = 

    [<Literal>]
    let EventsFileName = "events.json"

    let initialize () = 
        match File.Exists(EventsFileName) with
        | true -> ()
        | false -> File.AppendAllText(EventsFileName, "[]")

    let loadEvents() =
        File.ReadAllText EventsFileName
        |> JsonConvert.DeserializeObject<StoreEvent[]>
        |> Array.sortBy(fun event -> event.OperationDate)

    let saveEvents (events:StoreEvent[]) =
        loadEvents()
        |> fun storedEvents -> [|events; storedEvents|] |> Array.concat
        |> JsonConvert.SerializeObject
        |> fun eventsJson -> File.WriteAllText(EventsFileName, eventsJson)