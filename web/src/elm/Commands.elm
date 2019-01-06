module Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Msgs exposing (Msg)
import Models.Dto exposing (..)
import RemoteData exposing (WebData)

-- HTTP

fetchTasks : Cmd Msg
fetchTasks =
    Http.get
        {
            url = fetchTasksUrl,
            expect = Http.expectJson Msgs.OnFetchTasks tasksDecoder
        }

completeTask : CompleteTaskDto -> Cmd Msg
completeTask completeTaskDto = 
    Http.request
        {   
            method = "PUT",
            url = completeTaskUrl,
            body = Http.jsonBody (completeTaskEncoder completeTaskDto),
            expect = Http.expectWhatever Msgs.OnCompleteTask,
            timeout = Nothing,
            tracker = Nothing,
            headers = []
        }

changeTaskDueDate : ChangeTaskDueDateDto -> Cmd Msg
changeTaskDueDate taskDueDateDto = 
    Http.request
        {   
            method = "PUT",
            url = changeTaskDueDateUrl,
            body = Http.jsonBody (changeTaskDueDateEncoder taskDueDateDto),
            expect = Http.expectWhatever Msgs.OnUpdateTaskDueDate,
            timeout = Nothing,
            tracker = Nothing,
            headers = []
        }

deleteAllTasks : Cmd Msg
deleteAllTasks = 
    Http.request
        {
            method = "DELETE",
            url = removeAllTasksUrl,
            body = Http.emptyBody,
            expect = Http.expectWhatever Msgs.OnRemoveAllTasks,
            timeout = Nothing,
            tracker = Nothing,
            headers = []
        }

addNewTask : AddNewTaskDto -> Cmd Msg
addNewTask addNewTaskDto = 
    Http.post
        {
            url = addNewTaskUrl,
            body = Http.jsonBody (addNewTaskEncoder addNewTaskDto),
            expect = Http.expectWhatever Msgs.OnNewTaskAdded
        }

-- Urls

mainApiUrl : String
mainApiUrl = "http://localhost:5000/api/"

fetchTasksUrl : String
fetchTasksUrl =
    String.concat [mainApiUrl, "tasks"]

completeTaskUrl : String
completeTaskUrl = 
    String.concat [mainApiUrl, "task/complete"]

changeTaskDueDateUrl : String
changeTaskDueDateUrl = 
    String.concat [mainApiUrl, "task/date"]

removeAllTasksUrl : String
removeAllTasksUrl = 
    String.concat [mainApiUrl, "tasks"]

addNewTaskUrl : String
addNewTaskUrl = 
    String.concat [mainApiUrl, "task"]

-- Encoders, Decoders

tasksDecoder : Decode.Decoder (List TaskDto)
tasksDecoder =
    Decode.list taskDecoder

taskDecoder : Decode.Decoder TaskDto
taskDecoder =
    Decode.map4
        TaskDto
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "dueDate" Decode.string)
        (Decode.field "isComplete" Decode.bool)

completeTaskEncoder : CompleteTaskDto -> Encode.Value
completeTaskEncoder completeTaskDto =
    Encode.object
     [
         ("id", (Encode.string completeTaskDto.id))
     ]

changeTaskDueDateEncoder : ChangeTaskDueDateDto -> Encode.Value
changeTaskDueDateEncoder taskDueDateDto =
    Encode.object
     [
         ("id", (Encode.string taskDueDateDto.id)),
         ("dueDate", (Encode.string taskDueDateDto.dueDate))
     ]

addNewTaskEncoder : AddNewTaskDto -> Encode.Value
addNewTaskEncoder taskDto =
    Encode.object
     [
         ("name", (Encode.string taskDto.name)),
         ("dueDate", (Encode.string taskDto.dueDate))
     ]