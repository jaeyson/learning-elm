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
  , Entry 4 "Rock-Star Ninja" 400 False
  ]


-- Update

type Msg
  = NewGame
  | Mark Int
  -- | ShareScore

update : Msg -> Model -> Model
update msg model =
  case msg of
    NewGame ->
      { model | gameNumber = model.gameNumber + 1
              , entries = initEntries
      }

    Mark id ->
      let
          markEntry e =
            case (e.id == id) of
              True ->
                { e | marked = (not e.marked)
                }

              False ->
                e
      in
          { model | entries = List.map markEntry model.entries
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

viewEntryList : List Entry -> Html Msg
viewEntryList entries =
  let
      listOfEntries =
        List.map viewEntryItem entries
  in
      ul [] listOfEntries

viewEntryItem : Entry -> Html Msg
viewEntryItem entry =
  li [ classList [ ("marked", entry.marked) ]
      , onClick (Mark entry.id)
      ]
    [ span [ class "phrase" ]
        [ text entry.phrase ]
    , span [class "points"]
        [ text (String.fromInt entry.points) ]
    ]




