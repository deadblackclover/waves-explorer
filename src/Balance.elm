module Balance exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (Decoder, field, int)


type alias Balance =
    { regular : Int
    , generating : Int
    , available : Int
    , effective : Int
    }


initBalance : Balance
initBalance =
    { regular = 0
    , generating = 0
    , available = 0
    , effective = 0
    }


balanceDecoder : Decoder Balance
balanceDecoder =
    JD.map4 Balance
        (field "regular" int)
        (field "generating" int)
        (field "available" int)
        (field "effective" int)


getBalance : String -> (Result Http.Error Balance -> msg) -> Cmd msg
getBalance address msg =
    let
        url =
            "https://nodes.wavesnodes.com/addresses/balance/details/" ++ address
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg balanceDecoder
        }


formatBalance : Int -> String
formatBalance balance =
    String.fromFloat (toFloat balance / 100000000) ++ " WAVES"


viewBalance : String -> Balance -> Html msg
viewBalance address balance =
    div [ class "address" ]
        [ div [ class "address__title" ]
            [ p [] [ text "Address" ]
            , p [] [ text ("/ " ++ address) ]
            ]
        , div [ class "balance__items" ]
            [ div []
                [ p [] [ text "Regular Balance" ]
                , p [] [ text (formatBalance balance.regular) ]
                ]
            , div []
                [ p [] [ text "Generating Balance" ]
                , p [] [ text (formatBalance balance.generating) ]
                ]
            , div []
                [ p [] [ text "Available Balance" ]
                , p [] [ text (formatBalance balance.available) ]
                ]
            , div []
                [ p [] [ text "Effective Balance" ]
                , p [] [ text (formatBalance balance.effective) ]
                ]
            ]
        ]
