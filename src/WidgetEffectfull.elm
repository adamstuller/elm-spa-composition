module WidgetEffectfull exposing (..)

-- import AltComposition exposing (..)
import Either exposing (Either)
import Html exposing (Html)
import AltComposition exposing (Both)


type alias Subscription model msg =
    model -> Sub msg


type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


type alias View model msg =
    model -> Html msg


-- Widget


type alias WidgetEffectfull model msg =
    { init :  ( model, Cmd msg )
    , view : model -> Html msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }


-- join : WidgetEffectfull model1 msg1 -> WidgetEffectfull model2 msg2 -> WidgetEffectfull (Both model1 model2) (Either msg1 msg2)
-- join w1 w2 =
--     { update = updateWith w1.update w2.update
--     , init = initWith w1.init w2.init
--     , view = composeViews w1.view w2.view
--     }
