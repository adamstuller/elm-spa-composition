module Navbar exposing (navbar)

import Html exposing (Html, a, b, div, li, text, ul)
import Html.Attributes exposing (href)
import List.Nonempty as NE
import Router exposing (Navbar)
import Url


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


navbar : Navbar msg
navbar routes state onNavbarExpandClicked url =
    div []
        [ text "The current URL is: "
        , b [] [ text (Url.toString url) ]
        , ul [] <|
            (NE.toList <|
                NE.map viewLink routes
            )
                ++ [ li [] [ a [ href "/topic/8/user/22" ] [ text "/topic/8/user/22" ] ] ]
        ]
