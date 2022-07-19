module Transaction exposing (..)

import Json.Decode as JD exposing (Decoder, field, int, string)


type alias Transaction =
    { type_ : Int
    , id : String
    , timestamp : Int
    , sender : String
    }


transactionDecoder : Decoder Transaction
transactionDecoder =
    JD.map4 Transaction
        (field "type" int)
        (field "id" string)
        (field "timestamp" int)
        (field "sender" string)
