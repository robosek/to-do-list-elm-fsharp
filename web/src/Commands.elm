module Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Msgs exposing (Msg)
import Models exposing (Task, CompleteTask)
import RemoteData exposing (WebData)

fetchTasks : Cmd Msg
fetchTasks =
    Http.get
        {
            url = fetchTasksUrl,
            expect = Http.expectJson Msgs.OnFetchTasks tasksDecoder  
        }

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
    Decode.map4
        Task
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "dueDate" Decode.string)
        (Decode.field "isComplete" Decode.bool)