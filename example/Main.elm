module Main exposing (main)

import Browser
import CheckBox
import Counter
import Html
import Utils exposing (wrapView)
import Widget exposing (join)


main =
    CheckBox.initWidget True
        |> join (Counter.initWidget 0)
        |> join (Counter.initWidget 1)
        |> join (Counter.initWidget 1)
        |> join (Counter.initWidget 2)
        |> join (Counter.initWidget 3)
        |> join (Counter.initWidget 4)
        |> join (CheckBox.initWidget True)
        |> join (CheckBox.initWidget True)
        |> join (CheckBox.initWidget True)
        |> join (CheckBox.initWidget True)
        |> join (CheckBox.initWidget True)
        |> wrapView -- adds debug print of model
        |> Browser.sandbox
