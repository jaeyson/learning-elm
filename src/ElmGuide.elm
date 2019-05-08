module ElmGuide exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


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
  (Loading, getRandomCatGif)



-- Update

type Msg
  = MorePlease
  | GotGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getRandomCatGif)
    GotGif result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)
        Err _ ->
          (Failure, Cmd.none)



-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- View

view : Model -> Html Msg
view model =
  div []
    [ h2 []
        [ text "Random Cats" ]
    , viewGif model
    ]

viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure ->
      div []
        [ text "error loading"
        , button [ onClick MorePlease ]
            [ text "Try again" ]
        ]
    Loading ->
      text "Loading..."
    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ]
            [ text "More Please" ]
        , img [ src url ]
            []
        ]



-- HTTP

getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat" 
    , expect = Http.expectJson GotGif gifDecoder
    }

gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)

{--

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
      text "I was unable to load your book..."
    Loading ->
      text "Loading..."
    Success fullText ->
      pre [] [ text fullText ]



isReasonableAge : String -> Result String Int
isReasonableAge input =
  case String.toInt input of
    Nothing ->
      Err "That is not a number!"
    Just age ->
      if age < 0 then
        Err "Please try again"
      else if age > 135 then
        Err "Are you turtle?"
      else
        Ok age



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { input : String
  }


init : Model
init =
  { input = "" }



-- UPDATE


type Msg
  = Change String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newInput ->
      { model | input = newInput }



-- VIEW


view : Model -> Html Msg
view model =
  case String.toFloat model.input of
    Just celsius ->
      viewConverter model.input "blue" (String.fromFloat (celsius * 1.8 + 32))

    Nothing ->
      viewConverter model.input "red" "???"


viewConverter : String -> String -> String -> Html Msg
viewConverter userInput color equivalentTemp =
  span []
    [ input [ value userInput, onInput Change, style "width" "40px" ] []
    , text "°C = "
    , span [ style "color" color ] [ text equivalentTemp ]
    , text "°F"
    ]



type MaybePost
  = Post { title : String, content : String }
  | NoTitle
  | NoContent
  | NoPost

toPost : String -> String -> MaybePost
toPost title content =
  case (String.trim title, String.trim content) of
    ("", "") ->
      NoPost
    ("", _) ->
      NoTitle
    (_, "") ->
      NoContent
    (_, _) ->
      Post { title = title, content = content }



type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge
toAge input =
  case String.toInt input of
    Just value ->
      Age value
    Nothing ->
      InvalidInput

--}
