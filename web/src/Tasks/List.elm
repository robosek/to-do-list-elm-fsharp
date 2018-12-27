module Tasks.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (Msg(..))
import Models exposing (Task)
import RemoteData exposing (WebData)

view : WebData(List Task) -> Html Msg
view tasks =
    div []
        [ nav
        , maybeList tasks
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Tasks" ],
          button [][text "Clear all tasks"] ]


maybeList : WebData(List Task) -> Html Msg
maybeList response = 
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success tasks ->
            list tasks

        RemoteData.Failure error ->
            text (toString error)


list : List Task -> Html Msg
list tasks =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ 
                      th [] [ text "Name" ]
                    , th [] [ text "DueDate" ]
                    , th [] [ text "IsCompleted" ]
                    , th [] [ text "Complete it!" ]
                    ]
                ]
            , tbody [] (List.map taskRow tasks)
            ]
        ]


taskRow : Task -> Html Msg
taskRow task =
    tr []
        [ 
          td [] [ text task.name ]
        , td [] [ text task.dueDate ]
        , td [] [ text (toString task.isCompleted)]
        , td [] [ button [][text "complete"]]
        , td [] []
        ]