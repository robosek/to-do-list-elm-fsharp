module Msgs exposing (..)

import Models.Domain exposing (..)
import Models.Dto exposing (..)
import Http
import RemoteData exposing (WebData)
import DatePicker exposing (defaultSettings)

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
    | SetNewTaskDatePicker DatePicker.Msg
    | SetTaskDatePicker Task DatePicker.Msg