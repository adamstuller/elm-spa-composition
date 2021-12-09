module Common exposing (Both, Route, Subscription, Update, View, Flags)

{-| This module contains basic types for elm architecture functions

# Both 

@docs Both 

# Subscription 

@docs Subscription

# Update 

@docs Update

# View 

@docs View

# Route 

@docs Route

# Flags 

@docs Flags

-}

import Html exposing (Html)
import Json.Decode

{-| Subscription function type

-}
type alias Subscription model msg =
    model -> Sub msg


{-| Update function type

-}
type alias Update model msg =
    msg -> model -> ( model, Cmd msg )


{-| View function type

-}
type alias View model msg =
    model -> Html msg


{-| Type representing route, for now just String

-}
type alias Route =
    String

{-| Simple type used for better readability of tuple

    Both a b == (a, b) 

-}
type alias Both a b =
    ( a, b )

{-| Flags type used in the router
-}
type alias Flags =
    Json.Decode.Value