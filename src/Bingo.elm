module Bingo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (toString)



-- Main

main =
  Browser.sandbox
    { init = initModel
    , update = update
    , view = view
    }



-- Model

type alias Model =
  { name : String
  , gameNumber : Int
  , entries : List Entry
  }

type alias Entry =
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

initEntries : List Entry
initEntries =
  [ Entry 1 "Future-Proof" 100 False
  , Entry 2 "Doing Agile" 200 False
  , Entry 3 "In The Cloud" 300 False
  , Entry 2 "Rock-Star Ninja" 400 False
  ]


-- Update

type Msg
  = NewGame
  -- | Mark
  -- | ShareScore

update : Msg -> Model -> Model
update msg model =
  case msg of
    NewGame ->
      { model | gameNumber = model.gameNumber + 1
      }



-- View

view model =
  div [ class "content" ]
    [ viewHeader "Buzzword Bingo"
    , viewPlayer model.name model.gameNumber
    , viewEntryList model.entries
    , div [ class "button-group" ]
        [ button [ onClick NewGame ]
            [ text "New Game" ]
        ]
    , div [ class "debug" ]
        [ text (Debug.toString model) ]
    , viewFooter
    ]

viewHeader title =
  header []
    [ h1 [] [ text title ] ]

viewFooter =
  footer []
    [ a [ href "https://elm-lang.org" ]
        [ text "Powered by Elm" ]
    ]

viewPlayer name gameNumber =
  let
      playerInfoText =
        playerInfo name gameNumber
        |> String.toUpper
        |> text
  in
      h2 []
        [ playerInfoText ]

playerInfo name gameNumber =
  name ++ " - Game #" ++ String.fromInt gameNumber

viewEntryList : List Entry -> Html msg
viewEntryList entries =
  let
      listOfEntries =
        List.map viewEntryItem entries
  in
      ul [] listOfEntries

viewEntryItem : Entry -> Html msg
viewEntryItem entry =
  li []
    [ span [ class "phrase" ]
        [ text entry.phrase ]
    , span [class "points"]
        [ text (String.fromInt entry.points) ]
    ]




