module Navbar exposing (footer, header)

import Alt exposing (Footer, Header)
import Html exposing (Html, a, b, div, li, text, ul)
import Html.Attributes exposing (href)
import Url


viewLink : String -> String -> Html msg
viewLink path value =
    li [] [ a [ href path ] [ text value ] ]


header : Header msg
header _ _ url =
    div []
        [ text "The current URL is: "
        , b [] [ text (Url.toString url) ]
        , ul [] <|
            [ viewLink "/topic/8/user/22" "/topic/8/user/22"
            , viewLink "/topic/9/user/23" "/topic/9/user/23"
            , viewLink "/checkbox" "/checkbox"
            , viewLink "/tiktok"  "/tiktok" 
            , viewLink "/simpleText" "/simpleText"
            , viewLink "/counter" "/counter"
            ]
        ]


footer : Footer msg
footer =
    div [] [ text "SIMPLE FOOTER" ]
