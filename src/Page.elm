module Page exposing
    ( PageWidget, PageWidgetComposition, ApplicationWithRouter
    , join, add
    )

{-| This module contains types and functions required for composition of Pages.


# Page types

@docs PageWidget, PageWidgetComposition, ApplicationWithRouter


# Page composition functions

@docs join, add

-}

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation
import Common exposing (Both, RouteParser, Subscription, Update, View)
import Composition exposing (oneOfInits, orInit, subscribeEither, updateEither, viewEither)
import Either exposing (Either(..))
import List.Nonempty exposing (Nonempty)
import Url


{-| Type for widet that represents page. Contains all basic elm architecture functions that need to be implemented in respective page modules.
-}
type alias PageWidget model msg flags =
    { init : Both (flags -> ( model, Cmd msg )) RouteParser
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


{-| Page composition in progress. Is created by join function.
-}
type alias PageWidgetComposition model msg path flags =
    { init : ( path -> flags -> ( model, Cmd msg ), Nonempty path, Nonempty RouteParser )
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


{-| Parameter for single page applications. Is created by attaching router to PageWidgetComposition
-}
type alias ApplicationWithRouter model msg flags =
    { init : flags -> Url.Url -> Navigation.Key -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    , onUrlChange : Url.Url -> msg
    , onUrlRequest : UrlRequest -> msg
    }


{-| Combines first two pages and creates PageWidgetComposition. Is followed by add function.
-}
join : PageWidget model1 msg1 flags -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) (Either () ()) flags
join w1 w2 =
    { init = oneOfInits w1.init w2.init
    , view = viewEither w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }


{-| Adds another PageWidget to PageWidgetComposition.
-}
add : PageWidgetComposition model1 msg1 path flags -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) (Either path ()) flags
add w1 w2 =
    { init = orInit w1.init w2.init
    , view = viewEither w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }
