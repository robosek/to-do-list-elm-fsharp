module Msgs exposing (..)

import Models exposing (..)
import Http
import RemoteData exposing (WebData)

type Msg =
    OnFetchTasks (Result Http.Error (List TaskDto))
    | OnCompleteTask (Result Http.Error ())
    | OnUpdateTaskDueDate (Result Http.Error ())
    | OnRemoveAllTasks (Result Http.Error ())
    | OnNewTaskAdded (Result Http.Error ())
    | CompleteTask CompleteTaskDto
    | RemoveAllTasks
    | ChangeTaskDueDate ChangeTaskDueDateDto
    | AddNewTask
    | SetTaskName String
    | SetTaskDueDate String