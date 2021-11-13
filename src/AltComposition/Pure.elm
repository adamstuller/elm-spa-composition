module AltComposition.Pure exposing (Update, View, composeViews, initWith, joinViews, updateWith, viewBoth, viewWith)

import AltComposition.Common exposing (Both)
import Either exposing (Either(..))
import Html exposing (Html)
import List


type alias View model msg =
    model -> Html msg


type alias Update model msg =
    msg -> model -> model



-- Init composition


initWith : model1 -> model2 -> Both model1 model2
initWith m1 m2 =
    ( m1, m2 )



-- Update composition


updateWith : Update model1 msg1 -> Update model2 msg2 -> Update (Both model1 model2) (Either msg1 msg2)
updateWith update1 update2 =
    Either.unpack (Tuple.mapFirst << update1) (Tuple.mapSecond << update2)



-- View composition


viewBoth : View model1 msg1 -> View model2 msg2 -> Both model1 model2 -> Both (Html (Either msg1 msg2)) (Html (Either msg1 msg2))
viewBoth view1 view2 ( model1, model2 ) =
    ( Html.map Left <| view1 model1, Html.map Right <| view2 model2 )


joinViews : View model1 msg1 -> View model2 msg2 -> Both model1 model2 -> List (Html (Either msg1 msg2))
joinViews view1 view2 ( model1, model2 ) =
    let
        ( h1, h2 ) =
            viewBoth view1 view2 ( model1, model2 )
    in
    [ h1, h2 ]


viewWith : View model2 msg2 -> (model1 -> List (Html msg1)) -> Both model1 model2 -> List (Html (Either msg1 msg2))
viewWith view2 hs ( model1, model2 ) =
    List.append (List.map (Html.map Left) <| hs model1) [ Html.map Right <| view2 model2 ]


composeViews : View model1 msg1 -> View model2 msg2 -> Both model1 model2 -> Html (Either msg1 msg2)
composeViews view1 view2 ( model1, model2 ) =
    let
        ( h1, h2 ) =
            viewBoth view1 view2 ( model1, model2 )
    in
    Html.div [] [ h1, h2 ]
