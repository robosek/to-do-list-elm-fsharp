module Utils exposing (..)

import Models.Domain exposing (..)
import Date exposing (..)
import DatePicker exposing (DateEvent(..), defaultSettings)

getMaybeString: Maybe String -> String
getMaybeString maybeText = 
    case maybeText of
        Just text -> text 
        Nothing -> ""

updateDate: Model -> DatePicker.DatePicker -> (Maybe Date) -> Model
updateDate model  datePicker maybeDate = 
    {tasks = model.tasks, newTask = {name = model.newTask.name, 
    date = {date = maybeDate, datePicker = datePicker, datePickerFx = model.newTask.date.datePickerFx}}, listStatus = model.listStatus}