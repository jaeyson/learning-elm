module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- Main


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- Model


type alias Model =
    { input : String
    , display : String
    }


init : Model
init =
    { input = ""
    , display = "Output goes here"
    }



-- Update


type Msg
    = Reverse String
    | Input String
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reverse newContent ->
            Model newContent (String.reverse newContent)

        Input str ->
            { model | input = str }

        Reset ->
            init



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.display ]
        , input
            [ placeholder "Enter an integer"
            , onInput Input
            , value model.input
            ]
            []
        , button
            [ onClick (Reverse model.input) ]
            [ text "Reverse" ]
        , button
            [ onClick Reset ]
            [ text "Reset" ]
        ]
