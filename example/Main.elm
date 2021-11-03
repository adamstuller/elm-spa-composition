module Main exposing (main)

import AltComposition exposing (join)
import Browser
import CheckBox
import Counter


main =
    CheckBox.initWidget True
        |> join (Counter.initWidget 0)
        |> join (Counter.initWidget 1)
        |> join (Counter.initWidget 2)
        |> join (Counter.initWidget 3)
        |> join (Counter.initWidget 4)
        |> join (CheckBox.initWidget True)
        |> join (CheckBox.initWidget True)
        |> Browser.sandbox
