module Blocks exposing (..)

import Block exposing (Block, blockDecoder)
import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD


getBlocks : Int -> Int -> (Result Http.Error (List Block) -> msg) -> Cmd msg
getBlocks from to msg =
    let
        url =
            "https://nodes.wavesnodes.com/blocks/seq/" ++ String.fromInt from ++ "/" ++ String.fromInt to

        blockListDecoder =
            JD.list blockDecoder
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg blockListDecoder
        }


item : (Int -> msg) -> (String -> msg) -> Block -> Html msg
item getBlock getBalance block =
    div [ class "list__item" ]
        [ div []
            [ a [ href "#", onClick (getBlock block.height) ] [ text (String.fromInt block.height) ]
            , p [] [ text (timestampToTime block.timestamp) ]
            ]
        , div []
            [ p [] [ text block.id ]
            , a [ href "#", onClick (getBalance block.generator) ] [ text block.generator ]
            ]
        ]


viewBlocks : msg -> msg -> (Int -> msg) -> (String -> msg) -> List Block -> Html msg
viewBlocks back next getBlock getBalance blocks =
    div [ class "blocks" ]
        [ div []
            [ div [ class "blocks__title" ]
                [ p [] [ text "Blocks" ]
                , div []
                    [ a [ href "#", onClick back ] [ text "< Back" ]
                    , a [ href "#", onClick next ] [ text "Next >" ]
                    ]
                ]
            , div [ class "blocks__head" ]
                [ p [] [ text "№ / Timestamp" ]
                , p [] [ text "Block ID / Generator" ]
                ]
            ]
        , div [] (List.map (item getBlock getBalance) blocks)
        ]
