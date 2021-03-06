module SimpleText exposing (Model, Msg, initPageWidget)

import Alt exposing (PageWidget, Params, RouteParser, View)
import Html exposing (..)
import Json.Decode exposing (Decoder, decodeValue, field, string)


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


initPageWidget : RouteParser -> String -> PageWidget Model Msg Params
initPageWidget parser defaultText =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )

        initWithFlags f =
            case decodeValue flagsDecoder f.flags of
                Ok decodedText ->
                    ( decodedText, Cmd.none )

                Err _ ->
                    ( defaultText, Cmd.none )
    in
    { init = ( initWithFlags, parser )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
