module Main exposing (main)

import Block exposing (Block, getBlock, initBlock, viewBlock)
import Blocks exposing (getBlocks, viewBlocks)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Info exposing (Info, getCurrentHeight, getVersion, initInfo, viewInfo)



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type Route
    = BlocksPage
    | BlockPage


type alias Model =
    { info : Info
    , route : Route
    , blocks : List Block
    , block : Block
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { info = initInfo
      , route = BlocksPage
      , blocks = []
      , block = initBlock
      }
    , Cmd.batch
        [ getVersion GotVersion
        , getCurrentHeight GotCurrentHeight
        ]
    )



-- UPDATE


type Msg
    = GotVersion (Result Http.Error String)
    | GotCurrentHeight (Result Http.Error Int)
    | GotBlocks (Result Http.Error (List Block))
    | GotBlock (Result Http.Error Block)
    | GetBlocks
    | GetBlock Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotVersion result ->
            case result of
                Ok version ->
                    ( { model
                        | info =
                            { version = version
                            , currentHeight = model.info.currentHeight
                            }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        GotCurrentHeight result ->
            case result of
                Ok height ->
                    ( { model
                        | info =
                            { version = model.info.version
                            , currentHeight = height
                            }
                      }
                    , getBlocks (height - 10) height GotBlocks
                    )

                Err _ ->
                    ( model, Cmd.none )

        GotBlocks result ->
            case result of
                Ok blocks ->
                    ( { model | route = BlocksPage, blocks = List.reverse blocks }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotBlock result ->
            case result of
                Ok block ->
                    ( { model | route = BlockPage, block = block }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GetBlocks ->
            let
                from =
                    model.info.currentHeight - 10

                to =
                    model.info.currentHeight
            in
            ( model, getBlocks from to GotBlocks )

        GetBlock height ->
            ( model, getBlock height GotBlock )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Waves Explorer"
    , body =
        [ header []
            [ div []
                [ img [ src "/img/waves-elm.png", onClick GetBlocks ] []
                , h1 [] [ text "Waves Explorer" ]
                ]
            , div []
                [ a [ href "https://github.com/waves-elm/waves-explorer", target "_blank" ]
                    [ img [ src "/img/github.svg" ] [] ]
                ]
            ]
        , main_ []
            [ viewInfo model.info
            , case model.route of
                BlocksPage ->
                    viewBlocks GetBlock model.blocks

                BlockPage ->
                    viewBlock model.block
            ]
        ]
    }
