module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- Main


main =
  Browser.sandbox { init = init
                  , view = view
                  , update = update
                  }



-- Model


type alias Model =
  { content : String
  , input : String
  }

init : Model
init =
  { content = ""
  , input = ""
  }



-- Update


type Msg
  = Content
  | Input String
  | Clear
  | Edit

update : Msg -> Model -> Model
update msg model =
  case msg of
    Content ->
      { model | content = model.input
              , input = "" }
    Input str ->
      { model | input = str }
    Clear ->
      init
    Edit ->
      { model | input = model.content }



-- View


view : Model -> Html Msg
view model =
  div []
    [ h3 [ onClick Edit ]
        [ text ("Content: " ++ model.content) ]
    , input [ type_ "text"
            , placeholder "enter content"
            , onInput Input
            , value (if model.input == "" then
                        ""
                      else
                        model.input)]
        []
    , button [ type_ "button", onClick Content ]
        [ text "Add" ]
    , button [ type_ "button", onClick Clear ]
        [ text "Clear" ]
    ]
