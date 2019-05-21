module ElmProgHttpGet exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
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

type alias Model =
  List String

init : () -> (Model, Cmd Msg)
init _ =
  ([]
  , Cmd.none
  )










-- Update

type Msg
  = SendHttpRequest
  | DataReceived (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SendHttpRequest ->
      (model, getText)


    DataReceived (Ok nicknameStr) ->
      let
          nicknames =
            String.split "," nicknameStr
      in
          (nicknames, Cmd.none)

    DataReceived (Err _) ->
      (model, Cmd.none)

url : String
url =
  "http://localhost:8006/old-school.txt"
  
getText =
  Http.get
    { url = url
    , expect = Http.expectString DataReceived
    }


-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- View

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick SendHttpRequest ]
        [ text "get data from server" ]
    , h3 []
        [ text "old school main characters" ]
    , ul []
        (List.map viewNickname model)
    ]

viewNickname : String -> Html Msg
viewNickname nickname =
  li [] [ text nickname ]
