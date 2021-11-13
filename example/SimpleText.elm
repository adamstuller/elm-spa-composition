module SimpleText exposing (Model, Msg, initPageWidget, initWidget)

import AltComposition.Pure exposing (View)
import Html exposing (..)
import Json.Decode exposing (Decoder, decodeValue, field, string)
import Page exposing (PageWidget, Route)
import Widget exposing (Widget)
import Router exposing (Flags)


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
initPageWidget route s =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )

        initWithFlags f =
            case decodeValue flagsDecoder f of
                Ok decodedString ->
                    (decodedString, Cmd.none)

                Err _ ->
                    (s, Cmd.none)
    in
    { init = ( initWithFlags, route )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
