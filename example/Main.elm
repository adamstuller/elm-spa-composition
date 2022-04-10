module Main exposing (main)

import Browser
import CheckBox
import Common exposing (basicParser)
import Counter
import Flip exposing (flip)
import Navbar
import Page
import ParamsInUrl
import Router
import SimpleText
import TicToc


title : String
title =
    "SPA simple demo"


main =
    ParamsInUrl.initPageWidget ParamsInUrl.parser
        |> Page.join (Counter.initPageWidget Counter.parser 12)
        |> flip Page.add (CheckBox.initPageWidget CheckBox.parser True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox2" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        -- |> flip Page.add (Counter.initPageWidget "/counter2" 1000)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox5" True)
        |> flip Page.add (TicToc.initPageWidget (basicParser "tiktok") 500)
        |> flip Page.add (SimpleText.initPageWidget (basicParser "simpleText") "Text from initialization")
        |> Router.initRouter title Navbar.navbar
        |> Browser.application
