module Helpers exposing (..)

import Time exposing (Month(..), millisToPosix, toDay, toHour, toMinute, toMonth, toSecond, toYear, utc)


toIntMonth : Month -> String
toIntMonth month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


toUtcString : Time.Posix -> String
toUtcString time =
    String.fromInt (toDay utc time)
        ++ "."
        ++ toIntMonth (toMonth utc time)
        ++ "."
        ++ String.fromInt (toYear utc time)
        ++ ", "
        ++ String.fromInt (toHour utc time)
        ++ ":"
        ++ String.fromInt (toMinute utc time)
        ++ ":"
        ++ String.fromInt (toSecond utc time)
        ++ " (UTC)"


timestampToTime : Int -> String
timestampToTime timestamp =
    toUtcString (millisToPosix timestamp)
