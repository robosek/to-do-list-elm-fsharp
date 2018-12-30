module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg(..))
import Models exposing (Model)
import Tasks.List
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser

view : Model -> Html Msg
view model =

    Grid.container [] [
        CDN.stylesheet,
        div []
            [ page model ]
    ]

page : Model -> Html Msg
page model =
    Tasks.List.view model