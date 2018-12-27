module Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (Task, CompleteTask)
import RemoteData

fetchTasks : Cmd Msg
fetchTasks =
    Http.get fetchTasksUrl tasksDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchTasks

fetchTasksUrl : String
fetchTasksUrl =
    "http://localhost:5000/api/tasks"

completeTaskUrl : String
completeTaskUrl = 
    "http://localhost:5000/api/task"


tasksDecoder : Decode.Decoder (List Task)
tasksDecoder =
    Decode.list taskDecoder


taskDecoder : Decode.Decoder Task
taskDecoder =
    decode Task
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "dueDate" Decode.string
        |> required "isComplete" Decode.bool