module Utils exposing (..)

getMaybeString: Maybe String -> String
getMaybeString maybeText = 
    case maybeText of
        Just text -> text 
        Nothing -> ""