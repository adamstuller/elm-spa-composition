module Router exposing (Navbar, emptyNavbar, initRouter)

import AltComposition exposing (Both)
import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (default, href)
import List.Nonempty as NE exposing (Nonempty)
import Page exposing (ApplicationWithRouter, PageWidgetComposition, Route, subscribeWith)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url.Url


type alias Navbar =
    Nonempty String -> Url.Url -> Html Msg


emptyNavbar : Navbar
emptyNavbar routingRules url =
    Html.div [] []


pathFromUrl : Nonempty ( path, Route ) -> Url.Url -> path
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
    String
    -> Navbar
    -> PageWidgetComposition model msg path
    -> ApplicationWithRouter (Both model Model) (Either msg Msg) ()
initRouter title n w =
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
                                        ( ( models, Model key internalUrl )
                                        , Cmd.map Right <|
                                            Nav.pushUrl key (Url.toString internalUrl)
                                        )

                                    Browser.External href ->
                                        ( ( models, Model key url )
                                        , Cmd.map Right <| Nav.load href
                                        )

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
            \( models, { url } ) ->
                { title = title
                , body =
                    [ Html.div []
                        [ Html.map Right <| n routes url
                        , Html.map Left <| w.view models
                        ]
                    ]
                }

        subscriptions =
            subscribeWith w.subscriptions (always Sub.none)
    in
    { init = \() -> init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = \url -> Right <| UrlChanged url
    , onUrlRequest = \urlRequest -> Right <| LinkClicked urlRequest
    }
