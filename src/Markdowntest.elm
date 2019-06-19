module Markdowntest exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Markdown as MD
import Http exposing (..)



-- Main

main =
  Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- Model

type Model
  = Failure
  | Loading
  | Success String

init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      -- { url = "https://elm-lang.org/assets/public-opinion.txt"
      { url = "https://gist.githubusercontent.com/jaeyson/7402006e9a6cb83efb533e87d3a29559/raw/8797a41f653336e4dcc5898ae22a5fbb25a042d4/til.md"
      , expect = Http.expectString GotText
      }
  )



-- Update

type Msg
  = GotText (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->

      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- View

type alias Document msg =
  { title : String
  , body : List (Html msg)
  }

view : Model -> Document Msg
view model =
  case model of
    Failure ->
      { title = "untitled"
      , body =
          [ pre [] [ text "error loading info" ] ]
      }
      -- pre [] [ text "error loading info" ]

    Loading ->
      { title = "untitled"
      , body =
          [ text "error loading info" ]
      }
      -- text "Loading..."

    Success fullText ->
      { title = "untitled"
      , body =
          [ MD.toHtml [ class "container" ] fullText ]
      }
      -- MD.toHtml [] fullText
      -- pre [] [ text fullText ]

{--
viewer =
  MD.toHtml []
  """

  # Apple Pie Recipe

  First, invent the universe. Then bake an apple pie.

  """
--}

