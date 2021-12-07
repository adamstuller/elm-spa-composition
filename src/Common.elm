module Common exposing (..)
import Html exposing (Html)


type alias Subscription model msg =
    model -> Sub msg


type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


type alias View model msg =
    model -> Html msg

type alias Route =
    String


type alias Both a b =
    ( a, b )
