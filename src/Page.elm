module Page exposing (..)

import Composition.Common exposing (Both)
import Composition.Effectfull exposing (oneOfInits, orInit, subscribeEither, updateEither)
import Composition.Pure exposing (View)
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
