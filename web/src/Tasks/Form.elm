module Tasks.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models exposing (Model)
import RemoteData exposing (WebData)
import Debug
import Utils exposing (..)

viewForm: Model -> Html Msg
viewForm model =
    
    div[class "card text-center"][
        div[class "card-body"][
        Html.form[onSubmit AddNewTask , class "form-row align-items-center"]
    [
        div[class "col-auto"][
            label[for "task-name", class "sr-only"][text "Name "],
            div[class "nput-group mb-2"][
                 input[type_ "text", 
                        placeholder "Task name",
                        onInput SetTaskName,
                        value (getMaybeString model.newTaskName),
                        class "form-control",
                        id "task-name"][]
                ]
            ],
        div [class "col-auto"][
            label[for "task-duedate", class "sr-only"][text "Due date"],
            div [class "nput-group mb-2"][
                 input[type_ "text", 
                    placeholder "Due date",
                    onInput SetTaskDueDate,
                    value (getMaybeString model.newTaskDate),
                    class "form-control",
                    id "task-duedate"][]
            ] 
        ],
        button[class "btn btn-primary mb-2"][text "Add new task"]
    ]          
        ]
    ]
   