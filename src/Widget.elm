module Widget exposing (..)

import Composition.Pure exposing (..)
import Composition.Common exposing (Both)
import Either exposing (Either)



-- Widget


type alias Widget model msg =
    { update : Update model msg
    , init : model
    , view : View model msg
    }


join : Widget model1 msg1 -> Widget model2 msg2 -> Widget (Both model1 model2) (Either msg1 msg2)
join w1 w2 =
    { update = updateWith w1.update w2.update
    , init = initWith w1.init w2.init
    , view = composeViews w1.view w2.view
    }
