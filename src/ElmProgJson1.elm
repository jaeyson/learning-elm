module ElmProgJson1 exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Http



-- Main

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- Model

