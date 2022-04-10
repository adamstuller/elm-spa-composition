module CheckBox exposing (Model, Msg, initPageWidget, parser)

import Common exposing (Route)
import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
import Page exposing (PageWidget)
import Url.Parser exposing (Parser)


parser : Parser (List String -> List String) (List String)
parser =
    Url.Parser.map [] (Url.Parser.s "checkbox")


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


initPageWidget : Route -> Bool -> PageWidget Model Msg flags
initPageWidget route bool =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )
    in
    { init = ( always ( init bool, Cmd.none ), route )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
