module SimpleText exposing (Model, Msg, initPageWidget)

import Common exposing (Flags, Route, View)
import Html exposing (..)
import Json.Decode exposing (Decoder, decodeValue, field, string)
import Page exposing (PageWidget)


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
