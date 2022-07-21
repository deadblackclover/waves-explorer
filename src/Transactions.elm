module Transactions exposing (..)

import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, field, int, string)


type alias Transaction =
    { id : String
    , type_ : Int
    , timestamp : Int
    , sender : String
    }


transactionDecoder : Decoder Transaction
transactionDecoder =
    JD.map4 Transaction
        (field "id" string)
        (field "type" int)
        (field "timestamp" int)
        (field "sender" string)


getTransactions : String -> (Result Http.Error (List (List Transaction)) -> msg) -> Cmd msg
getTransactions address msg =
    let
        url =
            "https://nodes.wavesnodes.com/transactions/address/" ++ address ++ "/limit/10"

        transactionListDecoder =
            JD.list (JD.list transactionDecoder)
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg transactionListDecoder
        }


titleTransactions : Html msg
titleTransactions =
    div []
        [ div [ class "transactions__title" ]
            [ p [] [ text "Transactions" ] ]
        , div [ class "transactions__head" ]
            [ p [] [ text "ID / Timestamp" ]
            , p [] [ text "Sender / Recipient" ]
            ]
        ]


item : (String -> msg) -> (String -> msg) -> Transaction -> Html msg
item getTransaction getBalance transaction =
    div [ class "list__item" ]
        [ div []
            [ a [ href "#", onClick (getTransaction transaction.id) ] [ text transaction.id ]
            , p [] [ text (timestampToTime transaction.timestamp) ]
            ]
        , div []
            [ a [ href "#", onClick (getBalance transaction.sender) ] [ text transaction.sender ] ]
        ]


viewTransactions : (String -> msg) -> (String -> msg) -> List Transaction -> Html msg
viewTransactions getTransaction getBalance transactions =
    div [ class "transactions" ]
        [ titleTransactions
        , div [] (List.map (item getTransaction getBalance) transactions)
        ]


emptyTransactions : Html msg
emptyTransactions =
    div [ class "transactions" ]
        [ titleTransactions ]
