module Models.Domain exposing (..)

import RemoteData exposing (WebData)
import Date exposing (Date, day, month, weekday, year)
import DatePicker exposing (DateEvent(..), defaultSettings)
import Time exposing (Weekday(..))
import Html.Attributes exposing (..)

type alias Model = 
    {
        tasks : WebData(List Task)
        ,newTask: NewTask
        ,listStatus: ListStatus
    }

type alias TaskDate = 
    {
        date: Maybe Date
        ,datePicker: DatePicker.DatePicker
        ,datePickerFx: Maybe (Cmd DatePicker.Msg)
    }

type alias NewTask =
    { 
        name: Maybe String
        ,date: TaskDate
    }


type alias Task = 
    {   
        id: String
        ,name: String
        ,isCompleted: Bool
        , dueDate: TaskDate
    }

type ListStatus = 
    OnlyNotCompleted
    | All

initialModel : Model
initialModel =
    let
        tasks = RemoteData.Loading
        (datePicker, datePickerFx) = DatePicker.init
        date = {date = Nothing, datePicker = datePicker, datePickerFx = Just datePickerFx}
    in
    {
        tasks = RemoteData.Loading,
        newTask = {name = Nothing, date = date },
        listStatus = All
    }

settings : DatePicker.Settings
settings =
    let
        isDisabled date =
            [ Sat, Sun ]
                |> List.member (weekday date)
    in
    { defaultSettings
        | isDisabled = isDisabled
        , inputClassList = [ ( "form-control", True ) ]
        , inputName = Just "date"
        , inputId = Just "date-field"
        , inputAttributes = [(required True)] 
    }