module Router exposing (..)

import AltComposition exposing (Both)
import Browser exposing (UrlRequest, application)
import Browser.Navigation as Nav
import Either exposing (Either(..))
import Html exposing (Html, b)
import List.Nonempty as NE
import Page exposing (ApplicationWithRouter, PageWidgetComposed, Subscription, Update, View, initWith, initWithRouter, subscribeWith, updateWith)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


subscriptions : Subscription Model Msg
subscriptions model =
    Sub.none


initRouter :
    PageWidgetComposed model msg flags path
    -> ApplicationWithRouter (Both model Model) (Either msg Msg) flags
initRouter w =
    let
        viewPaths =
            \_ ->
                { title = "SPA"
                , body =
                    [ Html.div []
                        [ Html.ul [] <|
                            NE.toList <|
                                NE.map
                                    (\( path, route ) ->
                                        Html.li []
                                            [ Html.text <| route ++ "  "
                                            , Html.text <| Debug.toString path
                                            ]
                                    )
                                    w.routingRules
                        ]
                    ]
                }
    in
    { init = initWithRouter w.init init
    , view = viewPaths
    , update = updateWith w.update update
    , subscriptions = subscribeWith w.subscriptions subscriptions
    , onUrlChange = \url -> Right <| UrlChanged url
    , onUrlRequest = \urlRequest -> Right <| LinkClicked urlRequest
    }
