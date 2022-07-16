module Main exposing (main)

import Browser
import Html exposing (..)
import Http
import Info exposing (getCurrentHeight, getVersion)



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
    { version : String
    , currentHeight : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { version = ""
      , currentHeight = 0
      }
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
                    ( { model | version = version }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotCurrentHeight result ->
            case result of
                Ok height ->
                    ( { model | currentHeight = height }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Test"
    , body =
        [ div []
            [ text "Version:"
            , text model.version
            ]
        , div []
            [ text "Current height:"
            , text (String.fromInt model.currentHeight)
            ]
        ]
    }
