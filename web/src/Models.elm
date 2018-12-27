module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model = 
    {
        tasks : WebData(List Task)
    }

initialModel : Model
initialModel =
    {
        tasks = RemoteData.Loading
    }

type alias Task =
    { id : String
    , name : String
    , dueDate : String
    , isCompleted: Bool
    }

type alias CompleteTask = 
    {
        id: String
    }