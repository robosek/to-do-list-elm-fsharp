module Tasks.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models.Domain exposing (..)
import RemoteData exposing (WebData)
import Debug
import Utils exposing (..)
import DatePicker exposing (defaultSettings)

viewForm: Model -> Html Msg
viewForm model =    
    div[class "card text-center"][
        div[class "card-body"][
        Html.form[onSubmit AddNewTask , class "form-row align-items-center", autocomplete False]
    [
        div[class "col-auto"][
            label[for "task-name", class "sr-only"][text "Name "],
            div[class "nput-group mb-2"][
                 input[type_ "text", 
                        placeholder "Task name",
                        onInput SetTaskName,
                        value (getMaybeString model.newTask.name),
                        class "form-control",
                        id "task-name"][]
                ]
            ],
        div [class "col-auto"][
            label[for "task-duedate", class "sr-only"][text "Due date"],
            div [class "nput-group mb-2"][
                DatePicker.view model.newTask.date.date settings model.newTask.date.datePicker
                |> Html.map SetNewTaskDatePicker
            ] 
        ],
        button[class "btn btn-primary mb-2"][text "Add new task"]
    ]          
        ]
    ]
   