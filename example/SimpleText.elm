module SimpleText exposing (Model, Msg, initPageWidget, initWidget)

import Composition.Pure exposing (View)
import Html exposing (..)
import Json.Decode exposing (Decoder, decodeValue, field, string)
import Page exposing (PageWidget, Route)
import Router exposing (Flags)
import Widget exposing (Widget)


flagsDecoder : Decoder String
flagsDecoder =
    field "text" string


type alias Model =
    String


type alias Msg =
    ()


init : String -> Model
init =
    identity


view : View Model Msg
view m =
    Html.text m


update : Msg -> Model -> Model
update =
    always identity


initWidget : String -> Widget Model Msg
initWidget s =
    { init = init s
    , update = update
    , view = view
    }


initPageWidget : Route -> String -> PageWidget Model Msg Flags
initPageWidget route defaultText =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )

        initWithFlags f =
            case decodeValue flagsDecoder f of
                Ok decodedText ->
                    ( decodedText, Cmd.none )

                Err _ ->
                    ( defaultText, Cmd.none )
    in
    { init = ( initWithFlags, route )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
