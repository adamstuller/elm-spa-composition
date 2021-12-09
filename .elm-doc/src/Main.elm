module Main exposing (main)

import Browser
import CheckBox
import Counter
import Flip exposing (flip)
import Page
import SimpleText
import TicToc
import Router
import Navbar


title : String
title =
    "SPA simple demo"


main =
    TicToc.initPageWidget "/titktok" 1000
        |> Page.join (Counter.initPageWidget "/counter" 12)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox2" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        |> flip Page.add (Counter.initPageWidget "/counter2" 1000)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox5" True)
        |> flip Page.add (TicToc.initPageWidget "/titktok2" 500)
        |> flip Page.add (SimpleText.initPageWidget "/simpletext" "Text from initialization")
        |> Router.initRouter title Navbar.navbar
        |> Browser.application
