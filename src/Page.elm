module Page exposing (..)

import AltComposition exposing (Both, View)
import Browser exposing (Document)
import Either exposing (Either(..))
import Html exposing (Html)
import List.Nonempty as NE exposing (Nonempty)


type alias Subscription model msg =
    model -> Sub msg


type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


type alias View model msg =
    model -> Html msg


{-| Combines two inits models to selector and list of paths.

This is a first step in the _"oneOfInits+[orInit]"-chain_.

-}
oneOfInits :
    (flags -> ( model1, Cmd msg1 ))
    -> (flags -> ( model2, Cmd msg2 ))
    -> ( Either () () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either () ()) )
oneOfInits init1 init2 =
    ( \path ->
        case path of
            Left () ->
                \flags -> Tuple.mapBoth Left (Cmd.map Left) <| init1 flags

            Right () ->
                \flags -> Tuple.mapBoth Right (Cmd.map Right) <| init2 flags
    , NE.cons (Left ()) <| NE.fromElement (Right ())
    )


{-| Adds an another init to the _"oneOfInits+[orInit]"-chain_.
-}
orInit :
    ( path -> flags -> ( model1, Cmd msg1 ), Nonempty path )
    -> (flags -> ( model2, Cmd msg2 ))
    -> ( Either path () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either path ()) )
orInit ( next, ps ) init2 =
    ( \path ->
        case path of
            Left p ->
                \flags ->
                    Tuple.mapBoth Left (Cmd.map Left) <| next p flags

            Right () ->
                \flags ->
                    Tuple.mapBoth Right (Cmd.map Right) <| init2 flags
    , NE.append
        (NE.map Left ps)
      <|
        NE.fromElement (Right ())
    )


{-| Updates one of two submodels using corresponding subupdate function.
-}
updateEither :
    Update model1 msg1
    -> Update model2 msg2
    -> Update (Either model1 model2) (Either msg1 msg2)
updateEither u1 u2 msg model =
    case ( msg, model ) of
        ( Left msg1, Left model1 ) ->
            Tuple.mapBoth Left (Cmd.map Left) <| u1 msg1 model1

        ( Right msg2, Right model2 ) ->
            Tuple.mapBoth Right (Cmd.map Right) <| u2 msg2 model2

        _ ->
            ( model, Cmd.none )


{-| Combines two subscriptions.
-}
subscribeEither :
    Subscription model1 msg1
    -> Subscription model2 msg2
    -> Subscription (Either model1 model2) (Either msg1 msg2)
subscribeEither s1 s2 model =
    case model of
        Left model1 ->
            Sub.map Left <| s1 model1

        Right model2 ->
            Sub.map Right <| s2 model2


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
    { init : flags -> ( model, Cmd msg )
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


type alias PageWidgetComposition model msg flags path =
    { init : ( path -> flags -> ( model, Cmd msg ), Nonempty path )
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    }


type alias PageWidgetComposed model msg flags path =
    { init :  flags -> ( model, Cmd msg )
    , view : View model msg
    , update : Update model msg
    , subscriptions : Subscription model msg
    , paths : Nonempty path
    }


type alias WidgetEffectfull model msg flags =
    { init : flags -> ( model, Cmd msg )
    , view : model -> Html msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }


join : PageWidget model1 msg1 flags -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) flags (Either () ())
join w1 w2 =
    { init = oneOfInits w1.init w2.init
    , view = eitherView w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }


add : PageWidgetComposition model1 msg1 flags path -> PageWidget model2 msg2 flags -> PageWidgetComposition (Either model1 model2) (Either msg1 msg2) flags (Either path ())
add w1 w2 =
    { init = orInit w1.init w2.init
    , view = eitherView w1.view w2.view
    , update = updateEither w1.update w2.update
    , subscriptions = subscribeEither w1.subscriptions w2.subscriptions
    }


toWidgetEffectful : PageWidgetComposition model msg flags path -> WidgetEffectfull model msg flags
toWidgetEffectful w =
    let
        ( select, paths ) =
            w.init

        path =
            NE.head paths

        init =
            select path

        view =
            \model -> Html.div [] [ w.view model ]
    in
    { init = init
    , view = view
    , update = w.update
    , subscriptions = w.subscriptions
    }


initApplication : PageWidgetComposition model msg flags path -> PageWidgetComposed model msg flags path
initApplication w =
    let
        ( select, paths ) =
            w.init

        path =
            NE.head paths

        init =
            select path

        view =
            \model -> Html.div [] [ w.view model ]
    in
    { init = init
    , view = view
    , update = w.update
    , subscriptions = w.subscriptions
    , paths = paths
    }
