module Transactions exposing (..)

import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Transaction exposing (Transaction)


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
        [ div []
            [ div [ class "transactions__title" ]
                [ p [] [ text "Transactions" ] ]
            , div [ class "transactions__head" ]
                [ p [] [ text "ID / Timestamp" ]
                , p [] [ text "Sender / Recipient" ]
                ]
            ]
        , div [] (List.map (item getBalance) transactions)
        ]
