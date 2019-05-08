module AdventOfCode exposing (..)

{-- Day 1: (Part 1) Chronal Calibration

sample = """
+15
-15
+8
"""

-- sumFreq : String -> Int
sumFreq input =
  input
  |> String.split "\n"
  |> List.filter (String.isEmpty >> not)
  |> List.filterMap String.toInt
  |> List.foldl (\currVal acc -> acc + currVal) 0

output =
  sumFreq sample

--}




{-- Day 1: (Part 2) Chronal Calibration
--}

sample = """
+15
-15
+8
"""

-- sumFreq : String -> Int
sumFreq input =
  input
  |> String.split "\n"
  |> List.filter (String.isEmpty >> not)
  |> List.filterMap String.toInt
  |> List.foldl (\currVal acc -> acc + currVal) 0

output =
  sumFreq sample

