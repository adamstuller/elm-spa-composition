module Navbar exposing (navbar)

import Html exposing (Html, a, b, div, li, text, ul)
import Html.Attributes exposing (href)
import List.Nonempty as NE
import Alt exposing (Navbar)
import Url


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


navbar : Navbar msg
navbar state onNavbarExpandClicked url =
    div []
        [ text "The current URL is: "
        , b [] [ text (Url.toString url) ]
        , ul [] <|
            [ li [] [ a [ href "/topic/8/user/22" ] [ text "/topic/8/user/22" ] ]
            , li [] [ a [ href "/topic/9/user/23" ] [ text "/topic/9/user/23" ] ]
            , li [] [ a [ href "/checkbox" ] [ text "checkbox" ] ]
            , li [] [ a [ href "/tiktok" ] [ text "tiktok" ] ]
            , li [] [ a [ href "/simpleText" ] [ text "simpleText" ] ]
            , li [] [ a [ href "/counter" ] [ text "counter" ] ]
            ]
        ]
