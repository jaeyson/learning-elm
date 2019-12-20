module FuzzTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (addOne, factorial)
import Test exposing (..)


suite : Test
suite =
    describe "My very first fuzz test"
        [ fuzz int "adds 1 to any integer" <|
            \num ->
                addOne num |> Expect.equal (num + 1)
        , test "Factorial of 5 should be 120" <|
            \_ ->
                factorial 5 |> Expect.equal 120
        , test "Factorial of 0 should be 1" <|
            \_ ->
                factorial 0 |> Expect.equal 1
        ]
