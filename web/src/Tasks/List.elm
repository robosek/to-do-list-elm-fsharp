module Tasks.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models exposing (..)
import RemoteData exposing (WebData)
import Debug
import Tasks.Form exposing (..)

view : Model -> Html Msg
view model =
    div []
        [ 
          viewForm model
        , nav
        , maybeList model.tasks
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Tasks" ],
          button [onClick RemoveAllTasks][text "Clear all tasks"] ]


maybeList : WebData(List TaskDto) -> Html Msg
maybeList response = 
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success tasks ->
            list tasks

        RemoteData.Failure error ->
            text (Debug.toString error)


list : List TaskDto -> Html Msg
list tasks =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ 
                      th [] [ text "Name" ]
                    , th [] [ text "IsCompleted" ]
                    , th [] [ text "Complete it!" ]
                    , th [] [ text "Due date" ]
                    ]
                ]
            , tbody [] (List.map taskRow tasks)
            ]
        ]


taskRow : TaskDto -> Html Msg
taskRow task =
    tr []
        [ 
          td [] [ text task.name ]
        , td [] [ text (if task.isCompleted then "Yes" else "No")]
        , td [] [ button [onClick (CompleteTask (CompleteTaskDto task.id))][text "Complete"]]
        , td [] [ 
                  div[][input[value task.dueDate, type_ "text"][], 
                  button [onClick (ChangeTaskDueDate (ChangeTaskDueDateDto task.id "2018-02-05"))][text "Change"]]
                ]
        , td [] []
        ]