module PublicOpinion exposing (..)

import Browser
import Html exposing (..)
import Http exposing (..)


-- Main

main =
  Browser.element
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
      { url = "https://elm-lang.org/assets/public-opinion.txt"
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

view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "cant load info"

    Loading ->
      text "loading"

    Success fullText ->
      pre [] [ text fullText ]

