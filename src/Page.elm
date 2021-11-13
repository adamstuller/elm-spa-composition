module Page exposing (..)

import AltComposition.Common exposing (Both)
import AltComposition.Effectfull exposing (oneOfInits, orInit, subscribeEither, updateEither)
import AltComposition.Pure exposing (View)
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Either exposing (Either(..))
import Html exposing (Html)
import List.Nonempty as NE exposing (Nonempty)
import Url


type alias Subscription model msg =
    model -> Sub msg


type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


type alias View model msg =
    model -> Html msg


type alias Route =
    String


initWith :
    (flags -> ( model1, Cmd msg1 ))
    -> (flags -> ( model2, Cmd msg2 ))
    -> (flags -> ( Both model1 model2, Cmd (Either msg1 msg2) ))
initWith init1 init2 flags =
    let
        ( m2, c2 ) =
            init2 flags

        ( m1, c1 ) =
            init1 flags
    in
    ( ( m1, m2 )
    , Cmd.batch
        [ Cmd.map Left c1
        , Cmd.map Right c2
        ]
    )


{-| Updates one of two submodels using corresponding subupdate function.
-}
updateWith :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Both model1 model2) (Either msg1 msg2)
updateWith u1 u2 =
    let
        applyL f m =
            Tuple.mapFirst (f m)
                >> (\( ( x, c ), y ) -> ( ( x, y ), Cmd.map Left c ))

        applyR f m =
            Tuple.mapSecond (f m)
                >> (\( x, ( y, c ) ) -> ( ( x, y ), Cmd.map Right c ))
    in
    Either.unpack (applyL u1) (applyR u2)


{-| Combines two subscriptions.
-}
subscribeWith :
    Subscription model1 msg1
    -> Subscription model2 msg2
    -> Subscription (Both model1 model2) (Either msg1 msg2)
subscribeWith s1 s2 ( m1, m2 ) =
    Sub.batch
        [ Sub.map Left <| s1 m1
        , Sub.map Right <| s2 m2
        ]


{-| Combines two views into view for the SUM of models.
-}
eitherView :
    View model1 msg1
    -> View model2 msg2
    -> View (Either model1 model2) (Either msg1 msg2)
eitherView v1 v2 m =
    case m of
        Left m1 ->
            Html.map Left <| v1 m1

        Right m2 ->
            Html.map Right <| v2 m2


type alias PageWidget model msg flags =
    { init : Both (flags -> ( model, Cmd msg )) Route
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


type alias PageWidgetComposition model msg path flags =
    { init : ( path -> flags -> ( model, Cmd msg ), Nonempty path, Nonempty Route )
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


type alias ApplicationWithRouter model msg flags =
    { init : flags -> Url.Url -> Navigation.Key -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    , onUrlChange : Url.Url -> msg
    , onUrlRequest : UrlRequest -> msg
    }


join : PageWidget model1 msg1 flags -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) (Either () ()) flags
join w1 w2 =
    { init = oneOfInits w1.init w2.init
    , view = eitherView w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }


add : PageWidgetComposition model1 msg1 path flags-> PageWidget model2 msg2 flags-> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) (Either path ()) flags
add w1 w2 =
    { init = orInit w1.init w2.init
    , view = eitherView w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }



-- toWidgetEffectful : PageWidgetComposition model msg  path -> WidgetEffectfull model msg
-- toWidgetEffectful w =
--     let
--         ( select, paths, routes ) =
--             w.init
--         path =
--             NE.head paths
--         init =
--             select path
--         view =
--             \model -> Html.div [] [ w.view model ]
--     in
--     { init = init
--     , view = view
--     , update = w.update
--     , subscriptions = w.subscriptions
--     }
