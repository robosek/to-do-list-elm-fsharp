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
    Html.form[onSubmit AddNewTask , class "form-container"]
    [
        label[][text "Task name", input[type_ "text", 
                                        placeholder "Task name",
                                        onInput SetTaskName,
                                        value (getMaybeString model.newTaskName)][]],

        label[][text "Due date", input[type_ "text", 
                                       placeholder "Due date",
                                       onInput SetTaskDueDate,
                                       value (getMaybeString model.newTaskDate)][]],
        button[][text "Submit"]
    ]          