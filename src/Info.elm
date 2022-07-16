module Info exposing (..)

import Http
import Json.Decode exposing (at, int, string)


getVersion : (Result Http.Error String -> msg) -> Cmd msg
getVersion msg =
    let
        url =
            "https://nodes.wavesnodes.com/node/version"

        decodeContent =
            at [ "version" ] string
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decodeContent
        }


getCurrentHeight : (Result Http.Error Int -> msg) -> Cmd msg
getCurrentHeight msg =
    let
        url =
            "https://nodes.wavesnodes.com/blocks/height"

        decodeContent =
            at [ "height" ] int
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decodeContent
        }
