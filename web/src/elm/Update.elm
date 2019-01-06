module Update exposing (..)

import Msgs exposing (Msg(..))
import Models.Domain exposing (..)
import Models.Dto exposing (..)
import RemoteData exposing (WebData)
import Commands exposing (..)
import Utils exposing (..)
import Http
import Date exposing (..)
import DatePicker exposing (DateEvent(..), defaultSettings)
import Mappings exposing (..)
import Utils exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchTasks response ->
            let
                datePickerFx = case model.newTask.date.datePickerFx of
                               Just fx -> fx
                               Nothing -> Cmd.none
            in
            ( { model | tasks = RemoteData.fromResult((mapToDomainTasksResult response)), newTask = {name = Nothing, 
                date = {date = Nothing, datePicker = model.newTask.date.datePicker, datePickerFx = model.newTask.date.datePickerFx }}}, 
             Cmd.map SetNewTaskDatePicker datePickerFx)
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
            (model, addNewTask (mapToAddTaskDto model.newTask.name model.newTask.date.date))
        SetTaskName name ->
            ({model | newTask = {name = Just name, date = model.newTask.date}}, Cmd.none)
        SetTaskDueDate date ->
            (model ,Cmd.none)
        SetNewTaskDatePicker subMsg ->
            let
                ( newDatePicker, event ) =
                    DatePicker.update settings subMsg model.newTask.date.datePicker
                prepareNewDate = updateDate model newDatePicker
                maybeDate = case event of
                            Picked date -> Just date
                            _ -> model.newTask.date.date
                updatedModel = prepareNewDate maybeDate
            in
            ( updatedModel
            , Cmd.none
            )
        SetTaskDatePicker task subMsg->
            let
                (newDatePicker, event) = DatePicker.update settings subMsg task.dueDate.datePicker
                maybeDate = case event of
                            Picked date -> Just date
                            _ -> task.dueDate.date
                updatedTask = {id = task.id, name = task.name, isCompleted = task.isCompleted, 
                              dueDate = {date = maybeDate, datePicker = newDatePicker, 
                              datePickerFx = task.dueDate.datePickerFx}}
                updatedTasks =  model.tasks |> RemoteData.map(List.filter(\t -> t.id /= task.id) >> List.append [updatedTask])
                updatedModel = { model | tasks = updatedTasks }
            in
            (updatedModel, Cmd.none)