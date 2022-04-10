module Composition exposing (oneOfInits, orInit, updateEither, subscribeEither, viewEither, initWith, updateWith, subscribeWith)

{-| This module contains functions responsilble for composition of basic elm architecture functions


# Either composition

This composition creates new functions with sum of models of its respective partial functions

@docs oneOfInits, orInit, updateEither, subscribeEither, viewEither


# Both composition

This composition creates new functions with tuple of models of its respective partial functions

@docs initWith, updateWith, subscribeWith

-}

import Common exposing (Both, RouteParser, Subscription, Update, View)
import Either exposing (Either(..))
import Html exposing (Html)
import List.Nonempty as NE exposing (Nonempty)


{-| Starts the combination of init functions. Adding another init function is done by orInit function. 

-}
oneOfInits :
    Both (flags -> ( model1, Cmd msg1 )) RouteParser
    -> Both (flags -> ( model2, Cmd msg2 )) RouteParser
    -> ( Either () () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either () ()), Nonempty RouteParser )
oneOfInits ( init1, route1 ) ( init2, route2 ) =
    ( \path ->
        case path of
            Left () ->
                \flags -> Tuple.mapBoth Left (Cmd.map Left) <| init1 flags

            Right () ->
                \flags -> Tuple.mapBoth Right (Cmd.map Right) <| init2 flags
    , NE.cons (Left ()) <| NE.fromElement (Right ())
    , NE.cons route1 <| NE.fromElement route2
    )


{-| Adds an another init to init composition
-}
orInit :
    ( path -> flags -> ( model1, Cmd msg1 ), Nonempty path, Nonempty RouteParser )
    -> Both (flags -> ( model2, Cmd msg2 )) RouteParser
    -> ( Either path () -> flags -> ( Either model1 model2, Cmd (Either msg1 msg2) ), Nonempty (Either path ()), Nonempty RouteParser )
orInit ( next, ps, routes ) ( init2, route2 ) =
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
    , NE.append routes <|
        NE.fromElement route2
    )


{-| Combines two init functions.
-}
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



--- Update Composition

{-| Is composition of two update functions creating sum of their models. This function updates one of the submodels.
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


{-| Is composition of two update functions creating tuple of their models. This function updates one of the submodels.
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



--- Subscribe composition


{-| Combines two subscriptions creating tuple of models.
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


{-| Combines two subscriptions creating sum of models.
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



--- View composition


{-| View composition expecting tuple of models
-}
viewEither :
    View model1 msg1
    -> View model2 msg2
    -> View (Either model1 model2) (Either msg1 msg2)
viewEither v1 v2 m =
    case m of
        Left m1 ->
            Html.map Left <| v1 m1

        Right m2 ->
            Html.map Right <| v2 m2
