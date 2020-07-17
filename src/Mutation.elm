module Mutation exposing (..)


type alias Model a =
    { boolean : Maybe Bool
    , others : Maybe a
    }


init : Model a
init =
    { boolean = Nothing
    , others = Nothing
    }


type Any a
    = Boolean Bool
    | Others a


sample : Any a -> Model a -> Model a
sample usr model =
    case usr of
        Boolean val ->
            { init | boolean = Just val }

        Others val ->
            { init | others = Just val }


result : a -> Bool
result usr =
    case init.boolean /= Nothing of
        True ->
            True

        False ->
            False
