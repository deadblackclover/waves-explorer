module Main exposing (main)

import Browser
import Html exposing (..)
import Http
import Info exposing (Info, getCurrentHeight, getVersion, infoInit, infoView)



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { info : Info
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { info = infoInit }
    , Cmd.batch [ getVersion GotVersion, getCurrentHeight GotCurrentHeight ]
    )



-- UPDATE


type Msg
    = GotVersion (Result Http.Error String)
    | GotCurrentHeight (Result Http.Error Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotVersion result ->
            case result of
                Ok version ->
                    ( { model | info = { version = version, currentHeight = model.info.currentHeight } }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotCurrentHeight result ->
            case result of
                Ok height ->
                    ( { model | info = { version = model.info.version, currentHeight = height } }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Test"
    , body =
        [ infoView model.info
        ]
    }
