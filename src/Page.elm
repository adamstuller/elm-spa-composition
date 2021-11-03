module Page exposing (..)
import AltComposition exposing (..)
import Either exposing (Either)
-- Widget


type alias PageWidget model msg =
    { update : Update model msg
    , init : model
    , view : View model msg
    }


join : PageWidget model1 msg1 -> PageWidget model2 msg2 -> PageWidget (Both model1 model2) (Either msg1 msg2)
join w1 w2 =
    { update = updateWith w1.update w2.update
    , init = initWith w1.init w2.init
    , view = composeViews w1.view w2.view
    }
