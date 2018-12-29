module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import RemoteData exposing (WebData)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchTasks response ->
            ( { model | tasks = RemoteData.fromResult(response)}, Cmd.none )