module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchTasks response ->
            ( { model | tasks = response}, Cmd.none )