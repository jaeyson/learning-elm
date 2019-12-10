module Main exposing (addOne, factorial)


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
