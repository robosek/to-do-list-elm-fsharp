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
         maybeList model.tasks
        ]

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
        [ table [class "table"]
            [ thead [class "thead-dark"]
                [ tr []
                    [ 
                      th [] [ text "What to do?" ]
                    , th [] [ text "Status" ]
                    , th [] [ text "Deadline" ]
                    ]
                ]
            , tbody [] (List.map taskRow tasks)
            ]
        ]

completeButton : TaskDto -> Html Msg
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

changeDueDateForm : TaskDto -> Html Msg
changeDueDateForm taskDto =
    let 
        isActive = taskDto.isCompleted
        dto = ChangeTaskDueDateDto taskDto.id "2018-02-05"
    in
    div [class "form-inline"][
        div[][input[value taskDto.dueDate, type_ "text", class "form-control mx-sm-3 mb-2", disabled isActive][], 
        button [onClick (ChangeTaskDueDate dto), class "btn btn-primary mb-1", hidden isActive][text "Change"]]
    ]


taskRow : TaskDto -> Html Msg
taskRow task =
    tr []
        [ 
          td [] [ taskDescription task.name ]
        , td [] [ completeButton task ]
        , td [] [ changeDueDateForm task ]
        ]