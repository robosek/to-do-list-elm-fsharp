module Models.Dto exposing (..)

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