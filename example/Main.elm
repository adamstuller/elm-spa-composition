module Main exposing (main)

import Browser
import CheckBox
import Counter
import Flip exposing (flip)
import Navbar
import Page
import ParamsInUrl
import Router
import SimpleText
import TicToc
import Url.Parser


title : String
title =
    "SPA simple demo"


main =
    ParamsInUrl.initPageWidget { route = "/topic/11/user/23", parser = ParamsInUrl.parser }
        |> Page.join (Counter.initPageWidget { route = "/counter", parser = Counter.parser } 12)
        |> flip Page.add (CheckBox.initPageWidget { route = "/checkbox", parser = CheckBox.parser } True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox2" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        -- |> flip Page.add (Counter.initPageWidget "/counter2" 1000)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        -- |> flip Page.add (CheckBox.initPageWidget "/checkbox5" True)
        -- |> flip Page.add (TicToc.initPageWidget "/titktok2" 500)
        -- |> flip Page.add (SimpleText.initPageWidget {route = "/simpletext", parser = SimpleText.parser }"Text from initialization")
        |> Router.initRouter title Navbar.navbar
        |> Browser.application
