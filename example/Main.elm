module Main exposing (main)

import Browser
import CheckBox
import Counter
import Flip exposing (flip)
import Html
import Page
import Router
import TicToc
import Utils exposing (wrapView)
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
--         |> wrapView -- adds debug print of model
--         |> Browser.sandbox


main =
    TicToc.initPageWidget "/titktok" 1000
        |> Page.join (Counter.initPageWidget "/counter" 12)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox2" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox3" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox4" True)
        |> flip Page.add (CheckBox.initPageWidget "/checkbox5" True)
        |> Router.initRouter
        |> Browser.application



{--
    -> router 
    -> componenty 
        -> stateless - funkcia
        -> statefull - typovy sucin
    -> session*
    -> 


    -> prerobenie ukazkovej aplikacie
    -> upratanie 
    -> dokoncim:
        -> analyze rozsirit spa 
        -> navrh a dokumentacia
        -> plan na dalsi 

    ----------------------------------
    -> prerobit ten elm-spa-example

    KAPITOLA navrh
        specifikacia - bez konkretnych veci, co by sa malo robit - vid hore router atd
        widfet
        stranka 
        router

    PLAN na posledny semester
        -> prerob
        -> popis overenie 
--}
