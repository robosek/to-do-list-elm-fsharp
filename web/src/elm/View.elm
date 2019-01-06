module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msgs exposing (Msg(..))
import Models.Domain exposing (Model)
import Tasks.List
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser
import Tasks.Form exposing (..)

view : Model -> Html Msg
view model =

    Grid.container [] [
        CDN.stylesheet,
        div[class "row"][div[class "col align-self-center"]
        [h1 [class "text-center"][text "To do list"],page model]]
    ]

page : Model -> Html Msg
page model =
    div[][
        viewForm model,
        Tasks.List.view model
    ]