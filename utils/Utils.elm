module Utils exposing (wrapView)

import Debug
import Html
import Widget exposing (Widget)


wrapView : Widget model msg -> Widget model msg
wrapView w =
    { init = w.init
    , update = w.update
    , view = \model -> Html.div [] [ w.view <| model, Html.text <| Debug.toString <| model ]
    }
