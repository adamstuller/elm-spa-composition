module Utils exposing (wrapView)

import Debug
import Html
import Widget exposing (Widget)
-- import Page exposing (WidgetEffectfull)


wrapView : Widget model msg -> Widget model msg
wrapView w =
    { init = w.init
    , update = w.update
    , view = \model -> Html.div [] [ w.view <| model, Html.text <| Debug.toString <| model ]
    }



-- wrapViewEffects :  WidgetEffectfull model msg flags -> WidgetEffectfull model msg flags
-- wrapViewEffects w =
--     { init = w.init
--     , update = w.update
--     , view = \model -> Html.div [] [ w.view <| model, Html.text <| Debug.toString <| model ]
--     , subscriptions = w.subscriptions
--     }