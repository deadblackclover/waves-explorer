module Transactions exposing (..)

import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD
import Transaction exposing (Transaction, transactionDecoder)


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


item : (String -> msg) -> Transaction -> Html msg
item getBalance transaction =
    div [ class "list__item" ]
        [ div []
            [ a [ href "#" ] [ text transaction.id ]
            , p [] [ text (timestampToTime transaction.timestamp) ]
            ]
        , div []
            [ a [ href "#", onClick (getBalance transaction.sender) ] [ text transaction.sender ] ]
        ]


viewTransactions : (String -> msg) -> List Transaction -> Html msg
viewTransactions getBalance transactions =
    div [ class "transactions" ]
        [ titleTransactions
        , div [] (List.map (item getBalance) transactions)
        ]


emptyTransactions : Html msg
emptyTransactions =
    div [ class "transactions" ]
        [ titleTransactions ]
