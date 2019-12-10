module Practice exposing (..)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes as Attrib exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)



{--
{
  "ATL": "https://stats.nba.com/media/img/teams/logos/ATL_logo.svg"
  "DEN": "https://stats.nba.com/media/img/teams/logos/DEN_logo.svg"
}
--}
-- Main


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { teamHome : String
    , teamAway : String
    }


init =
    { teamHome = ""
    , teamAway = ""
    }



-- Update


type Msg
    = SelectHome String
    | SelectAway String


update msg model =
    case msg of
        SelectHome teamCode ->
            selectHome teamCode model

        SelectAway teamCode ->
            selectAway teamCode model


selectHome teamCode model =
    case extractHomeValue teamCode of
        Ok url ->
            { model
                | teamHome = url
            }

        Err _ ->
            model


selectAway teamCode model =
    case extractAwayValue teamCode of
        Ok url ->
            { model
                | teamAway = url
            }

        Err _ ->
            model


extractHomeValue teamCode =
    decodeValue (decoderHome teamCode) json


extractAwayValue teamCode =
    decodeValue (decoderAway teamCode) json


decoderHome teamCode =
    Decode.map Model (field teamCode Decode.string)


decoderAway teamCode =
    Decode.map Model (field teamCode Decode.string)


json =
    Encode.object
        [ ( "ATL", Encode.string "https://stats.nba.com/media/img/teams/logos/ATL_logo.svg" )
        , ( "DEN", Encode.string "https://stats.nba.com/media/img/teams/logos/DEN_logo.svg" )
        ]


view model =
    div []
        [ h1 [] [ text "Select Team" ]
        , input [ id "teamLogo", Attrib.list "logo" ]
            []
        , datalist [ id "logo" ]
            [ option
                [ Attrib.value "Atlanta Hawks"
                , onClick (SelectHome "ATL")
                ]
                [ text "ATL" ]
            , option [ Attrib.value "Denver Nuggets" ]
                [ text "DEN" ]
            , option [ Attrib.value "LA Clippers" ]
                [ text "LAC" ]
            , option [ Attrib.value "Phoenix Suns" ]
                [ text "PHX" ]
            ]
        , debugSection model
        ]


debugSection model =
    div []
        [ h3 []
            [ text "Home: "
            , text (Debug.toString model.teamHome)
            ]
        ]



{--

input:

    var input1 = { "number": 5 }
    var input2 = { "number": [ 1,2,3 ] }


expected:

    output1 = [5]
    output2 = [1,2,3]

decoder : Decoder (List Int)
decoder =
  oneOf
    [ list int
    , map List.singleton int
    ]
  |> field "number"





input:

    var input = { "name": "parent",
                  "children": [
                    { "name": "foo",
                      "value": 5
                    },
                    { "name": "empty",
                      "children": []
                    }
                  ]
                };


expected:

    Branch "parent"
      [ Leaf "foo" 5
      , Branch "empty" []
      ]

type Tree
  -- Either a branch with a name and a list of subtrees
  = Branch String (List Tree)
  -- or we're at a leaf, and we just have a name and a value
  | Leaf String Int

decoder : Decoder Tree
decoder =
  oneOf
    [ branchDecoder
    , leafDecoder
    ]

branchDecoder : Decoder Tree
branchDecoder =
  map2 Branch
    (field "name" string)
    (field "children" (list <| lazy (\_ -> decoder)))

leafDecoder : Decoder Tree
leafDecoder =
  map2 Leaf
    (field "name" string)
    (field "value" int)

--}
