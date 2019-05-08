module Practice exposing (..)
import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)


-- Main

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }



-- Model

type alias Model =
  { name : String
  , playerHome : List PlayerHome
  , playerAway : List PlayerAway
  , scoreHome : Int
  , scoreAway : Int
  , id : Maybe String
  , inputTeam : String
  }

type alias PlayerHome =
  { name : String
  , totalPointsScored : Int
  , id : String
  }

type alias PlayerAway =
  { name : String
  , totalPointsScored : Int
  , id : String
  }

init : Model
init =
  { name = ""
  , playerHome = []
  , playerAway = []
  , scoreHome = 0
  , scoreAway = 0
  , id = Nothing
  , inputTeam = ""
  }



-- Update

type Msg
  = Input String
  | Team String
  | ClearButton
  | SaveButton
  | EditPlayer String String String
  | DeletePlayer String
  | ScoreButton Int String
  | ResetPlayerScore String

update : Msg -> Model -> Model
update msg model =
  case msg of

    ClearButton ->
      { model | name = ""
              , inputTeam = ""
              , id = Nothing
      }

    Input name ->
      { model | name = name
      }

    Team name ->
      { model | inputTeam = name
      }


    SaveButton ->
      case (String.isEmpty model.name) of
        True ->
          { model | name = ""
          }

        False ->
          save model

    EditPlayer playerName playerId team ->
      { model | name = playerName
              , id =  Just playerId
              , inputTeam = team
      }

    DeletePlayer playerName ->
      delete model playerName

    ScoreButton points playerId ->
      score model points playerId

    ResetPlayerScore playerId ->
      resetPlayerScore model playerId

save model =
  case model.id of
    Just playerId ->
      edit model playerId
    Nothing ->
      add model
  {--
  let
      isDuplicateContent =
        model.contents
        |> List.map .content
        |> List.member model.input
  in
      case isDuplicateContent of
        True ->
          edit model

        False ->
          add model
  --}

add model =
  case model.inputTeam of
    "Home" ->
      addHomePlayerName model model.name

    "Away" ->
      addAwayPlayerName model model.name

    _ ->
      { model | name = ""
              , inputTeam = ""
              , id = Nothing
      }

-- helper for add function
addHomePlayerName model playerName =
  let
      newPlayer =
        PlayerHome playerName 0 ("Home" ++ (String.fromInt (List.length model.playerHome)))
      allPlayers =
        newPlayer :: model.playerHome
  in
      { model | playerHome = allPlayers
              , id = Nothing
              , name = ""
              , inputTeam = ""
      }

addAwayPlayerName model playerName =
  let
      newPlayer =
        PlayerAway playerName 0 ("Away" ++ (String.fromInt (List.length model.playerAway)))
      allPlayers =
        newPlayer :: model.playerAway
  in
      { model | playerAway = allPlayers
              , id = Nothing
              , name = ""
              , inputTeam = ""
      }
-- addHomePlayerName model.away "WTF???"



-- edit model playerId
edit model playerId =
  case model.inputTeam of
    "Home" ->
      editHomePlayerName model playerId

    "Away" ->
      editAwayPlayerName model playerId

    _ ->
      model

-- helper for edit function
editHomePlayerName model playerId =
  let
      result =
        model.playerHome
        |> List.map (\player ->
            case (player.id == playerId) of
              True ->
                { player | name = model.name
                }
              False ->
                player
          )
  in
      { model | playerHome = result
              , id = Nothing
              , name = ""
              , inputTeam = ""
      }

editAwayPlayerName model playerId =
  let
      result =
        model.playerAway
        |> List.map (\player ->
            case (player.id == playerId) of
              True ->
                { player | name = model.name
                }
              False ->
                player
          )
  in
      { model | playerAway = result
              , id = Nothing
              , name = ""
              , inputTeam = ""
      }

delete model playerName =
  let
      home =
        model.playerHome
        |> List.filter (\player -> player.name /= playerName)

      away =
        model.playerAway
        |> List.filter (\player -> player.name /= playerName)
  in
      case ((List.isEmpty home), (List.isEmpty away)) of
        (True,True) ->
          { model | playerHome = home
                  , playerAway = away
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }
        (True,False) ->
          { model | playerHome = home
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }
        (False,True) ->
          { model | playerAway = away
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }
        (False,False) ->
          model
  {--
  case model.inputTeam of
    "Home" ->
      let
          result =
            model.playerHome
            |> List.filter (\player -> player.name /= playerName)
      in
          { model | playerHome = result
          }

    "Away" ->
      let
          result =
            model.playerAway
            |> List.filter (\player -> player.name /= playerName)
      in
          { model | playerAway = result
          }

    _ ->
      model
  --}

score model points playerId =
  case model.inputTeam of
    "Home" ->
      let
          result =
            model.playerHome
            |> List.map (\player ->
                case (player.id == playerId) of
                  True ->
                    addPlayerScore player points
                  False ->
                    player
              )
      in
          { model | playerHome = result
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }

    "Away" ->
      let
          result =
            model.playerAway
            |> List.map (\player ->
                case (player.id == playerId) of
                  True ->
                    addPlayerScore player points
                  False ->
                    player
              )
      in
          { model | playerAway = result
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }

    _ ->
      model

-- helper for score function
addPlayerScore model points =
  { model | totalPointsScored = model.totalPointsScored + points
  }

resetPlayerScore model playerId =
  case model.inputTeam of
    "Home" ->
      let
          result =
            model.playerHome
            |> List.map (\player ->
                case (player.id == playerId) of
                  True ->
                    { player | totalPointsScored = 0 }
                  False ->
                    player
              )
      in
          { model | playerHome = result
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }

    "Away" ->
      let
          result =
            model.playerAway
            |> List.map (\player ->
                case (player.id == playerId) of
                  True ->
                    { player | totalPointsScored = 0 }
                  False ->
                    player
              )
      in
          { model | playerAway = result
                  , id = Nothing
                  , name = ""
                  , inputTeam = ""
          }

    _ ->
      model

  {--
  let
      result =
        model.players
        |> List.map (\scorePlayer ->
            if scorePlayer.id == scorePlayerId then
              { scorePlayer | totalPointsScored = scorePlayer.totalPointsScored + points }
            else
              scorePlayer
          )
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }
  --}

-- View

view : Model -> Html Msg
view model =
  div []
    [ div [ class "row" ]
        [ div [ class "col" ]
            [ div [ class "header-score" ]
                [ h1 [] [ text "Home" ]
                , h2 [] [ text "Score" ]
                ]
            , h3 [ class "header-player" ]
                [ span [] [ text "Name" ]
                , span [] [ text "Points" ]
                ]
            , playerSectionHome model
            ]
        , div [ class "col" ]
            [ div [ class "header-score" ]
                [ h1 [] [ text "Away" ]
                , h2 [] [ text "Score" ]
                ]
            , h3 [ class "header-player" ]
                [ span [] [ text "Name" ]
                , span [] [ text "Points" ]
                ]
            , playerSectionAway model
            ]
        ]
    , div [ class "row" ]
        [ div [ class "col" ]
            [ playerInput model
            , debugSection model
            ]
        ]
    ]

playerSectionHome model =
  model.playerHome
  |> List.map playerHome
  |> ul []

playerSectionAway model =
  model.playerAway
  |> List.map playerAway
  |> ul []

playerHome playerModel =
  li []
    [ i [ class "fa fa-trash-alt"
        , onClick (DeletePlayer playerModel.name)
        ]
        []
    , i [ class "fa fa-edit"
        , onClick (EditPlayer playerModel.name playerModel.id "Home")
        ]
        []
    , span [ class "player-name"
            , onClick (EditPlayer playerModel.name playerModel.id "Home")
            ]
        [text (playerModel.name) ]
    , span [ class "points-group" ]
        [ button [ type_ "button"
                  , onClick (ScoreButton -1 playerModel.id)
                  ]
            [ text "-" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 1 playerModel.id)
                  ]
            [ text "1" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 2 playerModel.id)
                  ]
            [ text "2" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 3 playerModel.id)
                  ]
            [ text "3" ]
        , button [ type_ "button"
                  , onClick (ResetPlayerScore playerModel.id)
                  ]
            [ text "R" ]
        ]
    , span [ class "player-score" ]
        [ text (String.fromInt playerModel.totalPointsScored) ]
    ]

playerAway playerModel =
  li []
    [ i [ class "fa fa-trash-alt"
        , onClick (DeletePlayer playerModel.name)
        ]
        []
    , i [ class "fa fa-edit"
        , onClick (EditPlayer playerModel.name playerModel.id "Away")
        ]
        []
    , span [ class "player-name"
            , onClick (EditPlayer playerModel.name playerModel.id "Away")
            ]
        [text (playerModel.name) ]
    , span [ class "points-group" ]
        [ button [ type_ "button"
                  , onClick (ScoreButton -1 playerModel.id)
                  ]
            [ text "-" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 1 playerModel.id)
                  ]
            [ text "1" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 2 playerModel.id)
                  ]
            [ text "2" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 3 playerModel.id)
                  ]
            [ text "3" ]
        , button [ type_ "button"
                  , onClick (ResetPlayerScore playerModel.id)
                  ]
            [ text "R" ]
        ]
    , span [ class "player-score" ]
        [ text (String.fromInt playerModel.totalPointsScored) ]
    ]

playerInput model =
  Html.form [ onSubmit SaveButton ]
    [ select [ onInput Team ]
        [ option [ value ""
                  , disabled True
                  , selected True
                  , hidden True
                  ]
            [ text "Select Team" ]
        , option [ value "Home" ]
            [ text "Home" ]
        , option [ value "Away" ]
            [ text "Away" ]
        ]
    , input [ type_ "text"
            , onInput Input
            , placeholder "Enter Player..."
            , value model.name
            ]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button"
              , class "button-cancel"
              , onClick ClearButton ]
        [ text "Cancel" ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 []
        [ text "Name: "
        , text (Debug.toString model.name)
        ]
    , h3 []
        [ text "Team: "
        , text (Debug.toString model.inputTeam)
        ]
    , h3 []
        [ text "Id: "
        , text (Debug.toString model.id)
        ]
    , h3 []
        [ text "Player - Home: "
        , text (Debug.toString model.playerHome)
        ]
    , h3 []
        [ text "Player - Away: "
        , text (Debug.toString model.playerAway)
        ]
    ]

