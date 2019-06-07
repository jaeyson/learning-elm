module Markdowntest exposing (..)

import Html exposing (..)
import Browser
import Markdown as MD



main =
  Browser.sandbox
    { init = "foo"
    , update = \_ m -> String.reverse m
    , view = \_ -> viewer
    }

viewer =
  MD.toHtml []
  """

  # Apple Pie Recipe

  First, invent the universe. Then bake an apple pie.

  """

