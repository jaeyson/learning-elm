module Bingo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (toString)
import Random
import Http



-- Main

main =
  Browser.element
    { init = initModel
    , update = update
    , subscriptions = subscriptions
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

initModel : () -> (Model , Cmd Msg)
initModel _ =
  ( { name = "Mike"
    , gameNumber = 1
    , entries = []
    }
  , getEntries
  )



-- Update

type Msg
  = NewGame
  | Mark Int
  | RandomNumber Int
  | NewEntries (Result Http.Error String)
  -- | ShareScore

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewGame ->
      ( { model | gameNumber = model.gameNumber + 1
        }
      , getEntries
      )

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
          ( { model | entries = List.map markEntry model.entries
            }
          , Cmd.none
          )

    RandomNumber id ->
      ( { model | gameNumber = id }
      , Cmd.none
      )

    NewEntries (Ok jsonString) ->
      let
          _ = "Ok" ++ Debug.toString jsonString

      in
          (model, Cmd.none)

    NewEntries (Err message) ->
      let
          _ = "Error" ++ Debug.toString message

      in
          (model, Cmd.none)



-- Commands

getRandomNumber : Cmd Msg
getRandomNumber =
  Random.generate RandomNumber (Random.int 1 100)

entriesUrl : String
entriesUrl =
  "http://localhost:8006/entries"

getEntries : Cmd Msg
getEntries =
  Http.get
    { url = entriesUrl
    , expect = Http.expectString NewEntries
    }


-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- View

view model =
  div [ class "content" ]
    [ viewHeader "Buzzword Bingo"
    , viewPlayer model.name model.gameNumber
    , viewEntryList model.entries
    , viewScore model.entries
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

viewScore entries =
  let
      totalPoints =
        entries
        |> List.filter .marked
        |> List.map .points
        |> List.sum
  in
      div []
        [ text (String.fromInt totalPoints) ]



