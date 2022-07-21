module Transaction exposing (..)

import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, field, int, string)


type alias Transaction =
    { id : String
    , type_ : Int
    , version : Int
    , timestamp : Int
    , height : Int
    , sender : String
    }


initTransaction : Transaction
initTransaction =
    { id = ""
    , type_ = 0
    , version = 0
    , timestamp = 0
    , height = 0
    , sender = ""
    }


transactionDecoder : Decoder Transaction
transactionDecoder =
    JD.map6 Transaction
        (field "id" string)
        (field "type" int)
        (field "version" int)
        (field "timestamp" int)
        (field "height" int)
        (field "sender" string)


getTransaction : String -> (Result Http.Error Transaction -> msg) -> Cmd msg
getTransaction id msg =
    let
        url =
            "https://nodes.wavesnodes.com/transactions/info/" ++ id
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg transactionDecoder
        }


viewTransaction : (Int -> msg) -> (String -> msg) -> Transaction -> Html msg
viewTransaction getBlock getBalance transaction =
    div [ class "transaction" ]
        [ div [ class "transaction__title" ]
            [ p [] [ text "Transaction" ]
            , p [] [ text ("/ " ++ transaction.id) ]
            ]
        , div [ class "transaction__items" ]
            [ div []
                [ p [] [ text "Type" ]
                , p [] [ text (String.fromInt transaction.type_) ]
                ]
            , div []
                [ p [] [ text "Version" ]
                , p [] [ text (String.fromInt transaction.version) ]
                ]
            , div []
                [ p [] [ text "Timestamp" ]
                , p [] [ text (timestampToTime transaction.timestamp) ]
                ]
            , div []
                [ p [] [ text "Block" ]
                , a [ href "#", onClick (getBlock transaction.height) ] [ text (String.fromInt transaction.height) ]
                ]
            , div []
                [ p [] [ text "Sender" ]
                , a [ href "#", onClick (getBalance transaction.sender) ] [ text transaction.sender ]
                ]
            ]
        ]
