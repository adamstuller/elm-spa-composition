module Counter exposing (Model, Msg, init, update, view, initWidget)

import AltComposition exposing (View, Widget, join)
import Debug
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


type alias Model =
    Int


type alias Msg =
    Int


init : Int -> Model
init =
    identity


view : View Model Msg
view m =
    let
        btn val lbl =
            button [ onClick val ] [ text lbl ]
    in
    span
        [ style "border" "2px outset"
        , style "padding" "2px"
        ]
        [ btn (m - 1) "-"
        , text <| Debug.toString m
        , btn (m + 1) "+"
        ]


update : Msg -> Model -> Model
update =
    always << max 0


initWidget : Int -> Widget Model Msg
initWidget int =
    { init = init int
    , update = update
    , view = view
    }
