module Page exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Common exposing (Both, View, Update, Subscription)
import Composition exposing (eitherView, oneOfInits, orInit, subscribeEither, updateEither)
import Either exposing (Either(..))
import Html exposing (Html)
import List.Nonempty as NE exposing (Nonempty)
import Url


type alias Route =
    String


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


add : PageWidgetComposition model1 msg1 path flags -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) (Either path ()) flags
add w1 w2 =
    { init = orInit w1.init w2.init
    , view = eitherView w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }
