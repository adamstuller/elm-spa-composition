module Main exposing (main)

import Browser
import CheckBox
import Counter
import Html
import Utils exposing (wrapView)
import Widget exposing (join)
import Page
import Flip exposing (flip)
import TicToc 
import Utils exposing (wrapViewEffects)
import Page

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
--         |> wrapView -- adds debug print of model
--         |> Browser.sandbox


main = Page.join (TicToc.initPageWidget 1000) (Counter.initPageWidget 12)
    |> flip Page.add (CheckBox.initPageWidget True)
    |> flip Page.add (TicToc.initPageWidget 500)
    |> flip Page.add (TicToc.initPageWidget 500)
    |> flip Page.add (TicToc.initPageWidget 500)
    -- |> Page.initApplication
    |> Page.toWidgetEffectful
    -- |> wrapViewEffects -- adds debug print of model
    |> Browser.element