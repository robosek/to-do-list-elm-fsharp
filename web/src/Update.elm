module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (..)
import RemoteData exposing (WebData)
import Commands exposing (..)
import Utils exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchTasks response ->
            ( { model | tasks = RemoteData.fromResult(response), newTaskName = Nothing, newTaskDate = Nothing}, Cmd.none )
        OnCompleteTask _ ->
            (model, fetchTasks)
        OnRemoveAllTasks _ -> 
            (model, fetchTasks)
        OnUpdateTaskDueDate _ -> 
            (model, fetchTasks)
        OnNewTaskAdded _ ->
            (model, fetchTasks)
        CompleteTask completeTaskDto -> 
            (model, completeTask completeTaskDto)
        RemoveAllTasks ->
            (model, deleteAllTasks)
        ChangeTaskDueDate taskDueDateDto ->
            (model, changeTaskDueDate taskDueDateDto)
        AddNewTask ->
            (model, addNewTask (AddNewTaskDto (getMaybeString model.newTaskName) (getMaybeString model.newTaskDate)))
        SetTaskName name ->
            ({model | newTaskName = Just(name)}, Cmd.none)
        SetTaskDueDate date ->
            ({model | newTaskDate = Just(date)}, Cmd.none)