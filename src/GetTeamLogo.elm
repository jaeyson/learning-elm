module GetTeamLogo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes as Attrib exposing (..)
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
  = ViewLogo String
  | GotLogo (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease teamCode ->
      (Loading, getTeamLogo teamCode)

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
    , input [ Attrib.list "team" ]
        []
    , datalist [ id "team" ]
        [ option [ Attrib.value ""
                  , Attrib.selected (model.inpuTeam == "")
                  , Attrib.disabled True
                  , Attrib.hidden True
                  ]
            []
        , option [ Attrib.value "Atlanta"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        , option [ Attrib.value "Boston"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        , option [ Attrib.value "Brooklyn"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        , option [ Attrib.value "Cleveland"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        , option [ Attrib.value "Phoenix"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        , option [ Attrib.value "Denver"
                  , Attrib.selected (model.inputTeam == "Home")
                  ]
            []
        ]
    , button [ onClick ViewLogo ]
        [ text "Select Team" ]
    , viewGif model
    ]

viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure ->
      div []
        [ text "cant load cat Gif"
        , button [ onClick ViewLogo ] [ text "try again" ]
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
getTeamLogo teamCode =
  Http.get
    { url = "https://gist.githubusercontent.com/jaeyson/60fe551b9ffb82da517bc50893b61da7/raw/a1f0353b9f22dab42d7e118efbdbc2a12ff1a25f/team.json"
    , expect = Http.expectJson GotLogo (logoDecoder teamCode)
    }

logoDecoder : String -> Decoder String
logoDecoder teamCode =
  field team (field "TeamLogoURL" string)
