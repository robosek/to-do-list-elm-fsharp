module Mappings exposing (..)

import Msgs exposing (Msg(..))
import Models.Domain exposing (..)
import Models.Dto exposing (..)
import RemoteData exposing (WebData)
import Commands exposing (..)
import Utils exposing (..)
import Http
import Date exposing (..)
import DatePicker exposing (DateEvent(..), defaultSettings)
import Time exposing (Weekday(..), Month(..))

mapToDomainTask: TaskDto -> Task
mapToDomainTask taskDto = 
    let
        maybeDate = (Result.toMaybe (Date.fromIsoString taskDto.dueDate))
        datePicker = DatePicker.initFromDate (Result.withDefault (Date.fromCalendarDate 1991 Sep 1) (Date.fromIsoString taskDto.dueDate))
    in
        {id= taskDto.id,
        name = taskDto.name, 
        isCompleted = taskDto.isCompleted
        ,dueDate = {date = maybeDate, datePicker = datePicker, datePickerFx = Nothing }}

mapToDomainTasksResult: (Result Http.Error (List TaskDto)) -> (Result Http.Error (List Task))
mapToDomainTasksResult resultTasks =
    resultTasks |> Result.map(List.map mapToDomainTask)

mapToAddTaskDto: (Maybe String) -> (Maybe Date) -> AddNewTaskDto
mapToAddTaskDto maybeName maybeDate = 
    let
        name = getMaybeString maybeName
        date = case maybeDate of
               Just d -> Date.toIsoString d
               Nothing -> "1990-01-01"
    in
        AddNewTaskDto name date