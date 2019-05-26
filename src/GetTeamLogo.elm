module GetTeamLogo exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes as Attrib exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Debug exposing (..)



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type alias Overview =
  { code : String
  , teamList : List Teams
  }

type alias Teams =
  { teamCity : String
  , teamName : String
  , teamID : Int
  , teamLogoURL : String
  }


type Model
  = Failure
  | Loading
  | Success String
  | Default


init : () -> (Model, Cmd Msg)
init _ =
  (Default, Cmd.none)
  -- (Loading, getTeamLogo)



-- UPDATE


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Select Team" ]
    , Html.form [ onSubmit MorePlease, autocomplete False ]
      [ input [ id "teamLogo", Attrib.list "logo" ]
          []
      , datalist [ id "logo" ]
          [ option [ Attrib.value "Atlanta Hawks" ]
              [ text "ATL" ]
          , option [ Attrib.value "Denver Nuggets" ]
              [ text "DEN" ]
          , option [ Attrib.value "LA Clippers" ]
              [ text "LAC" ]
          , option [ Attrib.value "Phoenix Suns" ]
              [ text "PHX" ]
          ]
      ]
    , viewLogo model
    -- , debugSection model
    ]


viewLogo : Model -> Html Msg
viewLogo model =
  case model of
    Default ->
      div []
        []

    Failure ->
      div []
        [ text "error loading"
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]

{--
debugSection model =
  div []
    [ h3 []
        [ text "Team: "
        , text (Debug.toString )
        ]
    ]
--}


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

