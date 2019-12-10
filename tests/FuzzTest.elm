module FuzzTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (addOne)
import Test exposing (..)


suite : Test
suite =
    describe "My very first fuzz test"
        [ fuzz int "adds 1 to any integer" <|
            \num ->
                addOne num |> Expect.equal (num + 1)
        ]
