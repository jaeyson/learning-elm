module GetTeamLogo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)



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
  | Default

init : () -> (Model, Cmd Msg)
init _ =
  (Default, Cmd.none)



-- Update

type Msg
  = MorePlease
  | GotLogo (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getTeamLogo)

    GotLogo result ->
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
    [ h2 [] [ text "Select Team" ]
    , input [ Html.Attributes.list "pet" ]
        []
    , datalist [ id "pet" ]
        [ option [ Html.Attributes.value ""
                  , hidden True
                  , selected True
                  ] []
        , option [ Html.Attributes.value "Atlanta" ] []
        , option [ Html.Attributes.value "Boston" ] []
        , option [ Html.Attributes.value "Phoenix" ] []
        , option [ Html.Attributes.value "Brooklyn" ] []
        , option [ Html.Attributes.value "Cleveland" ] []
        , option [ Html.Attributes.value "Sacramento" ] []
        ]
    , button [ onClick MorePlease ]
        [ text "Select Team" ]
    , viewGif model
    ]

viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure ->
      div []
        [ text "cant load cat Gif"
        , button [ onClick MorePlease ] [ text "try again" ]
        ]

    Loading ->
      text "loading..."

    Success url ->
      div []
        [ img [ src url ] []
        ]

    Default ->
      div []
        []



-- HTTP

getTeamLogo : Cmd Msg
getTeamLogo =
  Http.get
    { url = "https://gist.githubusercontent.com/jaeyson/60fe551b9ffb82da517bc50893b61da7/raw/a1f0353b9f22dab42d7e118efbdbc2a12ff1a25f/team.json"
    , expect = Http.expectJson GotLogo logoDecoder
    }

logoDecoder : Decoder String
logoDecoder =
  field "ATL" (field "TeamLogoURL" string)
