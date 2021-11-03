module CheckBox exposing (initWidget)

import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import Widget exposing (Widget)


type alias Model =
    Bool


type alias Msg =
    ()


init : Bool -> Model
init =
    identity


view : Model -> Html Msg
view state =
    Html.input
        [ checked state
        , type_ "checkbox"
        , onClick ()
        ]
        []


update : Msg -> Model -> Model
update =
    always not


initWidget : Bool -> Widget Model Msg
initWidget bool =
    { init = init bool
    , update = update
    , view = view
    }
