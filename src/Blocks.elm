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


item : (Int -> msg) -> Block -> Html msg
item msg block =
    div [ class "blocks__item" ]
        [ div [ class "item__height" ]
            [ a [ href "#", onClick (msg block.height) ] [ text (String.fromInt block.height) ]
            , p [] [ text (timestampToTime block.timestamp) ]
            ]
        , div [ class "item__id" ]
            [ p [] [ text block.id ]
            , a [ href "#" ] [ text block.generator ]
            ]
        ]


viewBlocks : (Int -> msg) -> List Block -> Html msg
viewBlocks msg blocks =
    div [ class "blocks" ]
        [ div []
            [ div [ class "blocks__title" ]
                [ p [] [ text "Blocks" ] ]
            , div [ class "blocks__head" ]
                [ p [] [ text "№ / Timestamp" ]
                , p [] [ text "Block ID / Generator" ]
                ]
            ]
        , div [] (List.map (item msg) blocks)
        ]
