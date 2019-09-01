module BasicInput exposing (..)

import Browser
import Html exposing (Html, div, text, h3, button)
import Html.Attributes as Attrib exposing (style)
import Html.Events exposing (onClick)



-- Main
main =
  Browser.sandbox
  { init = init
  , update = update
  , view = view
  }



-- Model
type alias Model =
  { value  : Int
  , display: String
  , toggle : String
  }

init : Model
init = Model 0 "block" "hide"



-- Update
type Msg
  = Increment
  | Decrement
  | Reset
  | Toggle

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | value = model.value + 1 }

    Decrement ->
      { model | value = model.value - 1 }
      --Model (model.value - 1) model.display model.toggle

    Reset ->
      { model | value = 0 }

    Toggle ->
      case model.display == "block" of
        True ->
          Model model.value "none" "show"

        False ->
          Model model.value "block" "hide"



-- View
view : Model -> Html Msg
view model =
  div [  ]
      [ h3  [ Attrib.style "display" model.display ]
            [ text (String.fromInt model.value) ]
      , button  [ onClick Increment ]
                [ text " + " ]
      , button  [ onClick Decrement ]
                [ text " - " ]
      , button  [ onClick Reset ]
                [ text "reset" ]
      , button  [ onClick Toggle ]
                [ text model.toggle ]
      ]

