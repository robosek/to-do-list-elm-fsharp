module Main exposing (..)

import Html exposing (..)
import Models exposing (Model, initialModel)
import View exposing (view)
import Update exposing (update)
import Msgs exposing (Msg(..))
import Commands exposing (fetchTasks)

-- Model 
init : (Model, Cmd Msg)

init  = (initialModel, fetchTasks)


--Subscriptions
subscriptions: Model -> Sub Msg

subscriptions model =
    Sub.none

--Main 
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }