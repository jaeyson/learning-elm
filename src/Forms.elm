module Forms exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)



-- Model

type alias Team =
  { players : List Player
  }

type alias Player =
  { name : String
  , id : Int
  }

type alias Model =
  { name : String
  , team : Team
  , id : Maybe Int
  }

init =
  { name = ""
  , team =
      { players = []
      }
  , id = Nothing
  }

sample =
  { name = ""
  , team =
      { players =
          [ { name = "Jordan", id = 0 }
          , { name = "Michelle", id = 3 }
          ]
      }
  , id = Nothing
  }



-- helper for add function
addData : String
  -> { a | players : List Player }
  -> { a | players : List Player }
addData playerName model =
  { model | players = Player playerName (List.length model.players) :: model.players }
-- sample.team |> addData "WTF???"

setData playerName model =
  { model | name = playerName }

{--}
result =
  sample.team.players
  |> List.map (\player ->
      case (player.id == 0) of
        True ->
          setData "Michael Jordan" player
        False ->
          player
    )
{--}
