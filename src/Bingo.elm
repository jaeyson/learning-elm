module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (toString)


-- Model

type alias Model =
  { name : String
  , gameNumber : Int
  , entries : List Entries
  }

type alias Entries =
    { id : Int
    , phrase : String
    , points : Int
    , marked : Bool
    }

initModel : Model
initModel =
  { name = "Mike"
  , gameNumber = 1
  , entries = initEntries
  }

initEntries : List Entries
initEntries =
  [ { id = 1, phrase = "Future-Proof", points = 100, marked = False }
  , { id = 2, phrase = "Doing Agile", points = 200, marked = False }
  ]


-- Update



-- View

main =
  view initModel


playerInfo name gameNumber =
  name ++ " - Game #" ++ String.fromInt gameNumber

viewPlayer name gameNumber =
  let
      playerInfoText =
        playerInfo name gameNumber
        |> String.toUpper
        |> text
  in
      h2 []
        [ playerInfoText ]

viewHeader title =
  header []
    [ h1 [] [ text title ] ]

viewFooter =
  footer []
    [ a [ href "https://elm-lang.org" ]
        [ text "Powered by Elm" ]
    ]

view model =
  div []
    [ viewHeader "Buzzword Bingo"
    , viewPlayer model.name model.gameNumber
    , debugSection model
    , viewFooter
    ]

debugSection model =
  section []
    [ h3 []
        [ text (Debug.toString model) ]
    ]



