module Msgs exposing (..)

import Models exposing (Task)
import Http

import RemoteData exposing (WebData)

type Msg =
    OnFetchTasks (Result Http.Error (List Task))