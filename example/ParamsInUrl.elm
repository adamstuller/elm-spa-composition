module ParamsInUrl exposing (Model, Msg, initPageWidget, parser)

import Alt exposing (PageWidget, Params, RouteParser, View)
import Html exposing (..)
import List exposing (head, tail)
import Url.Parser exposing ((</>), Parser)


parser : Parser (List String -> List String) (List String)
parser =
    Url.Parser.map
        (\topic user -> topic :: user :: [])
        (Url.Parser.s "topic" </> Url.Parser.string </> Url.Parser.s "user" </> Url.Parser.string)


listToParams : List String -> { user : String, topic : String }
listToParams list =
    { topic = Maybe.withDefault "" (head list)
    , user = Maybe.withDefault "" (head (Maybe.withDefault [] <| tail list))
    }


type alias Model =
    { topic : String
    , user : String
    }


type alias Msg =
    ()


view : View Model Msg
view m =
    Html.div []
        [ Html.p [] [ Html.text <| "User id: " ++ m.user ]
        , Html.p [] [ Html.text <| "Topic id: " ++ m.topic ]
        ]


update : Msg -> Model -> Model
update =
    always identity


initPageWidget : RouteParser -> PageWidget Model Msg Params
initPageWidget route =
    let
        updateEffectfull =
            \msg model -> ( update msg model, Cmd.none )

        initWithFlags f =
            ( listToParams <| Maybe.withDefault [] <| Url.Parser.parse parser f.url, Cmd.none )
    in
    { init = ( initWithFlags, route )
    , update = updateEffectfull
    , view = view
    , subscriptions = always Sub.none
    }
