module Main exposing (..)

import Html exposing (..)
import Models.Domain exposing (Model, initialModel)
import View exposing (view)
import Update exposing (update)
import Msgs exposing (Msg(..))
import Commands exposing (fetchTasks)
import Browser

-- Model 
init : () -> (Model, Cmd Msg)

init _ = (initialModel, fetchTasks)

--Subscriptions
subscriptions: Model -> Sub Msg

subscriptions model =
    Sub.none

--Main 
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }