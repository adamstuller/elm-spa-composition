module Counter exposing (initPageWidget, initWidget, Model, Msg)

import AltComposition.Pure exposing (View)
import Debug
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Page exposing (PageWidget, Route)
import Widget exposing (Widget)


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


initPageWidget : Route -> Int -> PageWidget Model Msg flags
initPageWidget route int =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )
    in
    { init = ( always ( init int, Cmd.none ), route )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
