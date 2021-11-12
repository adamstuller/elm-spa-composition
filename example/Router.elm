module Router exposing (..)

import AltComposition exposing (Both)
import Browser exposing (UrlRequest, application)
import Browser.Navigation as Nav
import Either exposing (Either(..))
import Html exposing (Html, a, b, div, li, select, text, ul)
import Html.Attributes exposing (default, href, style)
import Html.Events exposing (onClick)
import List.Nonempty as NE exposing (Nonempty)
import Page exposing (ApplicationWithRouter, PageWidgetComposition, Subscription, Update, View, initWith, initWithRouter, subscribeWith, updateWith)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url



-- updateRouter : Msg -> Model -> ( Model, Cmd Msg )
-- updateRouter msg model =
--     case msg of
--         LinkClicked urlRequest ->
--             case urlRequest of
--                 Browser.Internal url ->
--                     ( model, Nav.pushUrl model.key (Url.toString url) )
--                 Browser.External href ->
--                     ( model, Nav.load href )
--         UrlChanged url ->
--             ( { model | url = url }
--             , Cmd.none
--             )


subscriptions : Subscription Model Msg
subscriptions model =
    Sub.none


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


navbar : Nonempty String -> Url.Url -> Html Msg
navbar routingRules url =
    div []
        [ text "The current URL is: "
        , b [] [ text (Url.toString url) ]
        , ul [] <|
            NE.toList <|
                NE.map viewLink routingRules
        ]


pathFromUrl : Nonempty ( path, String ) -> Url.Url -> path
pathFromUrl rules url =
    let
        default =
            NE.head rules

        matchesUrl u ( p, r ) =
            r == u.path
    in
    NE.filter (matchesUrl url) default rules
        |> NE.head
        |> Tuple.first


initRouter :
    PageWidgetComposition model msg path
    -> ApplicationWithRouter (Both model Model) (Either msg Msg) ()
initRouter w =
    let
        ( select, paths, routes ) =
            w.init

        routingRules =
            NE.zip paths routes

        update =
            \msg ( models, { url, key } ) ->
                case msg of
                    Left subMsg ->
                        let
                            ( subModel, subCmd ) =
                                w.update subMsg models
                        in
                        ( ( subModel, Model key url ), Cmd.map Left subCmd )

                    Right routerMsg ->
                        case routerMsg of
                            LinkClicked urlRequest ->
                                case urlRequest of
                                    Browser.Internal internalUrl ->
                                        ( ( models, Model key internalUrl ), Cmd.map Right <| Nav.pushUrl key (Url.toString internalUrl) )

                                    Browser.External href ->
                                        ( ( models, Model key url ), Cmd.map Right <| Nav.load href )

                            UrlChanged newUrl ->
                                let
                                    ( subModel, subCmd ) =
                                        select (pathFromUrl routingRules newUrl)
                                in
                                ( ( subModel, Model key url )
                                , Cmd.map Left subCmd
                                )

        init url key =
            let
                ( model, cmd ) =
                    select (pathFromUrl routingRules url)
            in
            ( ( model, { key = key, url = url } ), Cmd.map Left cmd )

        view =
            \( models, { key, url } ) ->
                { title = "SPA"
                , body =
                    [ Html.div []
                        [ Html.map Right <| navbar routes url
                        , Html.map Left <| w.view models
                        ]
                    ]
                }
    in
    { init = \() -> init
    , view = view
    , update = update
    , subscriptions = subscribeWith w.subscriptions subscriptions
    , onUrlChange = \url -> Right <| UrlChanged url
    , onUrlRequest = \urlRequest -> Right <| LinkClicked urlRequest
    }
