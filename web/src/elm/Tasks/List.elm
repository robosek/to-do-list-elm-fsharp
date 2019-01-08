module Tasks.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models.Domain exposing (..)
import Models.Dto exposing (..)
import RemoteData exposing (WebData)
import Debug
import Tasks.Form exposing (..)
import DatePicker exposing (defaultSettings)
import Time exposing (Weekday(..), Month(..))
import Date exposing (Date, day, month, weekday, year)

view : Model -> Html Msg
view model =
    div []
        [ checkbox model.listStatus,
          maybeList model.tasks model.listStatus
        ]

maybeList : WebData(List Task) -> ListStatus -> Html Msg
maybeList response listStatus = 
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success tasks ->
            list tasks listStatus

        RemoteData.Failure error ->
            text (Debug.toString error)

checkbox : ListStatus -> Html Msg
checkbox listStatus =
    let
        isChecked = case listStatus of 
                    OnlyNotCompleted -> False
                    All -> True   
    in
        div[class "form-check"][
            input[class "form-check-input", type_ "checkbox", id "listCheckbox", checked isChecked, onClick (FilterTaskList listStatus)][],
            label[class "form-check-label", for "listCheckbox"][text "All tasks"]
        ]

list : List Task -> ListStatus -> Html Msg
list tasks listStatus =
    let
        filteredTasks = case listStatus of
                        OnlyNotCompleted -> tasks |> List.filter(\t -> t.isCompleted == False)
                        All -> tasks
    in
    
    div [ class "p2" ]
        [ table [class "table"]
            [ thead [class "thead-dark"]
                [ tr []
                    [ 
                      th [] [ text "What to do?" ]
                    , th [] [ text "Status" ]
                    , th [] [ text "Deadline" ]
                    ]
                ]
            , tbody [] (List.map taskRow (filteredTasks |> List.sortBy .name))
            ]
        ]

completeButton : Task -> Html Msg
completeButton taskDto =
    let 
        isDisabled = taskDto.isCompleted
        buttonText = if taskDto.isCompleted then "Completed" else "Complete"
        buttonClass = if taskDto.isCompleted then "btn btn-info" else "btn btn-success"
        dto = CompleteTaskDto taskDto.id
    in 
    button [onClick (CompleteTask dto), class buttonClass, disabled isDisabled][text buttonText]

taskDescription : String -> Html Msg
taskDescription description =
    h5 [][text description]

changeDueDateForm : Task -> Html Msg
changeDueDateForm task =
    let 
        isDisabled = task.isCompleted
        date = Maybe.withDefault (Date.fromCalendarDate 1991 Sep 1) task.dueDate.date
        dto = ChangeTaskDueDateDto task.id (Date.toIsoString date)
        defaultCss = [ ( "form-control", True ), ("max-sm-2", True), ("mb-2", True)]
        attributes = if isDisabled then settings.inputAttributes |> List.append [(disabled True)] else settings.inputAttributes
        datePickerSettings = {settings | inputClassList = defaultCss, inputAttributes = attributes}
    in
    Html.form [autocomplete False][
        div[class "form-inline"][
            DatePicker.view task.dueDate.date datePickerSettings task.dueDate.datePicker 
            |> Html.map (SetTaskDatePicker task),
            button [onClick (ChangeTaskDueDate dto), class "btn btn-primary mb-2", hidden isDisabled][text "Change"]]
    ]

taskRow : Task -> Html Msg
taskRow task =
    tr []
        [ 
          td [] [ taskDescription task.name ]
        , td [] [ completeButton task ]
        , td [] [ changeDueDateForm task ]
        ]