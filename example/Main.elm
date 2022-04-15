module Main exposing (main)

import Browser
import CheckBox
import Alt exposing (basicParser, initRouter, add, join)
import Counter
import Flip exposing (flip)
import Navbar
import ParamsInUrl
import SimpleText
import TicToc
import Alt exposing (emptyFooter)


title : String
title =
    "SPA simple demo"


main =
    ParamsInUrl.initPageWidget ParamsInUrl.parser
        |> join (Counter.initPageWidget Counter.parser 12)
        |> flip add (CheckBox.initPageWidget CheckBox.parser True)
        |> flip add (TicToc.initPageWidget (basicParser "tiktok") 500)
        |> flip add (SimpleText.initPageWidget (basicParser "simpleText") "Text from initialization")
        |> initRouter title Navbar.header Navbar.footer
        |> Browser.application
