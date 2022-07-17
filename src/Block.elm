module Block exposing (..)

import Helpers exposing (timestampToTime)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (Decoder, field, int, string)


type alias Block =
    { height : Int
    , id : String
    , version : Int
    , timestamp : Int
    , parentBlock : String
    , generator : String
    , signature : String
    }


initBlock : Block
initBlock =
    { height = 0
    , id = ""
    , version = 0
    , timestamp = 0
    , parentBlock = ""
    , generator = ""
    , signature = ""
    }


blockDecoder : Decoder Block
blockDecoder =
    JD.map7 Block
        (field "height" int)
        (field "id" string)
        (field "version" int)
        (field "timestamp" int)
        (field "reference" string)
        (field "generator" string)
        (field "signature" string)


getBlock : Int -> (Result Http.Error Block -> msg) -> Cmd msg
getBlock height msg =
    let
        url =
            "https://nodes.wavesnodes.com/blocks/at/" ++ String.fromInt height
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg blockDecoder
        }


viewBlock : Block -> Html msg
viewBlock block =
    div [ class "block" ]
        [ div [ class "block__title" ]
            [ p [] [ text "Block" ] ]
        , div [ class "block__items" ]
            [ div []
                [ p [] [ text "Height" ]
                , p [] [ text (String.fromInt block.height) ]
                ]
            , div []
                [ p [] [ text "ID" ]
                , p [] [ text block.id ]
                ]
            , div []
                [ p [] [ text "Version" ]
                , p [] [ text (String.fromInt block.version) ]
                ]
            , div []
                [ p [] [ text "Timestamp" ]
                , p [] [ text (timestampToTime block.timestamp) ]
                ]
            , div []
                [ p [] [ text "Parent block" ]
                , p [] [ text block.parentBlock ]
                ]
            , div []
                [ p [] [ text "Generator" ]
                , a [ href "#" ] [ text block.generator ]
                ]
            , div []
                [ p [] [ text "Signature" ]
                , p [] [ text block.signature ]
                ]
            ]
        ]
