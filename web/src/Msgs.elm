module Msgs exposing (..)

import Models exposing (Task)
import RemoteData exposing (WebData)

type Msg =
    OnFetchTasks (WebData (List Task))