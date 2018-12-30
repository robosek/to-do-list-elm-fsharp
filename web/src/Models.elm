module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model = 
    {
        tasks : WebData(List TaskDto),
        newTaskName: Maybe String,
        newTaskDate: Maybe String,
        taskUnderEdit: Maybe TaskDto
    }

initialModel : Model
initialModel =
    {
        tasks = RemoteData.Loading,
        newTaskDate = Nothing,
        newTaskName = Nothing,
        taskUnderEdit = Nothing
    }


-- DTO
type alias TaskDto =
    { id : String
    , name : String
    , dueDate : String
    , isCompleted: Bool
    }

type alias AddNewTaskDto =
    { 
      name : String
    , dueDate : String
    }
    
type alias CompleteTaskDto = 
    {
        id: String
    }

type alias ChangeTaskDueDateDto = 
    {
        id: String,
        dueDate: String
    }