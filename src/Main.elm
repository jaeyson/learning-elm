module Main exposing (..)

import Json.Decode as JD
import Json.Encode as JE


json =
    """
  [
    {
      "role": "admin",
      "email": "admin@email.com"
    },
    {
      "role": "regular",
      "email": "user@email.com"
    },
    { "email": "test@email.com" },
    { "other": "foo" }
  ]
  """


type User
    = Admin String
    | Regular String


regularDecoder =
    JD.map Regular (JD.field "email" JD.string)


adminDecoder =
    JD.map Admin (JD.field "email" JD.string)


userType string =
    case string of
        "regular" ->
            regularDecoder

        "admin" ->
            adminDecoder

        _ ->
            JD.fail <| "err"


userDecoder =
    JD.field "role" JD.string
        |> JD.andThen userType


output =
    JD.decodeString (JD.list userDecoder) json



---


addOne : Int -> Int
addOne =
    (+) 1


factorial : Int -> Int
factorial n =
    List.foldl (*) 1 (rangeHelper n [])


rangeHelper : Int -> List Int -> List Int
rangeHelper n list =
    let
        toHigh =
            (0 <= n) == True

        toLow =
            (0 >= n) == True
    in
    case ( toHigh, toLow ) of
        ( True, False ) ->
            rangeHelper (n - 1) (n :: list)

        ( False, True ) ->
            rangeHelper (n + 1) (n :: list)
                |> List.filter ((/=) 0)

        _ ->
            list
