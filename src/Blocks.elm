module Blocks exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (field, int, string)


type alias Block =
    { height : Int
    , timestamp : Int
    , id : String
    , generator : String
    }


getBlocks : Int -> Int -> (Result Http.Error (List Block) -> msg) -> Cmd msg
getBlocks from to msg =
    let
        url =
            "https://nodes.wavesnodes.com/blocks/seq/" ++ String.fromInt from ++ "/" ++ String.fromInt to

        blockDecoder =
            JD.map4 Block
                (field "height" int)
                (field "timestamp" int)
                (field "id" string)
                (field "generator" string)

        blockListDecoder =
            JD.list blockDecoder
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg blockListDecoder
        }


blockView : Block -> Html msg
blockView block =
    div [ class "block" ]
        [ div [ class "block__height" ]
            [ a [ href "#" ] [ text (String.fromInt block.height) ]
            , p [] [ text (String.fromInt block.timestamp) ]
            ]
        , div [ class "block__id" ]
            [ p [] [ text block.id ]
            , a [ href "#" ] [ text block.generator ]
            ]
        ]


blocksView : List Block -> Html msg
blocksView blocks =
    div [ class "blocks" ]
        [ div []
            [ div [ class "blocks__title" ]
                [ p [] [ text "Blocks" ] ]
            , div [ class "blocks__head" ]
                [ p [] [ text "№ / Timestamp" ]
                , p [] [ text "Block ID / Generator" ]
                ]
            ]
        , div [] (List.map blockView blocks)
        ]
