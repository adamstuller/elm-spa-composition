module Main exposing (main)

import Composition.Common exposing (Both)
import Browser
import CheckBox
import Counter
import Either exposing (Either)
import Flip exposing (flip)
import Navbar exposing (navbar)
import Page
import Platform exposing (Router)
import Router exposing (Navbar)
import SimpleText
import TicToc
import Widget exposing (join)



-- main =
--     CheckBox.initWidget True
--         |> join (Counter.initWidget 0)
--         |> join (Counter.initWidget 1)
--         |> join (Counter.initWidget 1)
--         |> join (Counter.initWidget 2)
--         |> join (Counter.initWidget 3)
--         |> join (Counter.initWidget 4)
--         |> join (CheckBox.initWidget True)
--         |> join (CheckBox.initWidget True)
--         |> join (CheckBox.initWidget True)
--         |> join (CheckBox.initWidget True)
--         |> join (CheckBox.initWidget True)
--         |> Browser.sandbox


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
