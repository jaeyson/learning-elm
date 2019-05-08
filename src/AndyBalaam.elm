{-- Slide 1
main =
  Browser.sandbox
    { init = "foo"
    , update = \_ m -> String.reverse m
    , view = \m -> button [ onClick 0 ] [ text m ]}
--}

{-- Slide 6
-- Model
type alias Model =
  { x : Float
  , y : Float
  , centreX : Float
  , centreY : Float
  }

-- View
view m =
...
  svg
    [ width "100"
    , height "40"
    ]
    [ ellipse
        [ cx "10", cy "34", rx "12", ry "16"
        , fill "white", stroke "black", strokeWidth "2px"
        ]
    ]

-- Update
update (MouseChange x y) model =
  ( { model | x = x
            , y = y
    }, Cmd.none )
--}

{-- Slide 10
-- Model
type alias Model =
  { email1 : String
  , email2 : String
  }

-- Update
type Msg
  = Email1Changed String
  | Email2Changed String

update msg model =
  case msg of
    Email1Changed s ->
      { model | email1 = s }
    Email2Changed s ->
      { model | email2 = s }

-- View
view model =
...
  div []
    [ button [submitDisabled model]
        [text "Submit"]
    ]
...

submitDisabled model =
  disabled
    ( (validEmail1 model /= Valid)
    || (validEmail2 model /= Valid) )
--}
