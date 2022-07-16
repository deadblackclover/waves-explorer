module Info exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (at, int, string)


type alias Info =
    { version : String
    , currentHeight : Int
    }


infoInit : Info
infoInit =
    { version = ""
    , currentHeight = 0
    }


getVersion : (Result Http.Error String -> msg) -> Cmd msg
getVersion msg =
    let
        url =
            "https://nodes.wavesnodes.com/node/version"

        decoder =
            at [ "version" ] string
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decoder
        }


getCurrentHeight : (Result Http.Error Int -> msg) -> Cmd msg
getCurrentHeight msg =
    let
        url =
            "https://nodes.wavesnodes.com/blocks/height"

        decoder =
            at [ "height" ] int
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decoder
        }


infoView : Info -> Html msg
infoView info =
    div [ class "info" ]
        [ div [ class "info__version" ]
            [ p [] [ text "Version:" ]
            , p [] [ text info.version ]
            ]
        , div [ class "info__height" ]
            [ p [] [ text "Current height:" ]
            , p [] [ text (String.fromInt info.currentHeight) ]
            ]
        ]
