module CheckBox exposing (Model, Msg, initPageWidget, parser)

import Alt exposing (RouteParser, PageWidget)
import Html exposing (Html)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)
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


initPageWidget : RouteParser -> Bool -> PageWidget Model Msg flags
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
