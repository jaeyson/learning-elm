{--
type alias User =
  { name : String
  , bio : String
  }

-- hasBio : User -> String
hasBio : User -> Bool
hasBio user =
  String.length user.bio > 15
--  case (String.length user.bio > 15) of
--    True -> "True"
--    False -> "False"

type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge
toAge userInput =
  case (String.toInt userInput) of
    Just int ->
      Age int
    Nothing ->
      InvalidInput

toAge : String -> String
toAge userInput =
  case (String.toInt userInput) of
    Just int ->
      "Age " ++ String.fromInt int
    Nothing ->
      "InvalidInput"

type MaybePost
  = Post { title : String, content : String  }
  | NoTitle
  | NoContent
  | NoPost

toPost : String -> String -> MaybePost
toPost title content =
  case (String.trim title, String.trim content) of
    ("", "") ->
      NoPost
    ("", _) ->
      NoTitle
    (_, "") ->
      NoContent
    (_, _) ->
      Post { title = title, content = content }

type alias Item =
  { name : String
  , price : Float
  , qty : Int
  , discounted : Bool
  }

cart : List Item
cart =
  [ { name = "Lemon", price = 0.5, qty = 1, discounted = False }
  , { name = "Apple", price = 1.0, qty = 5, discounted = False }
  , { name = "Pear", price = 1.25, qty = 10, discounted = False }
  ]

fiveOrMoreDiscount : Item -> Item
fiveOrMoreDiscount item =
  case item.qty >= 5 of
    True ->
      { item | price = item.price * 0.8
              , discounted = True
      }
    False ->
      item

discount : Int -> Float -> Item -> Item
discount minQty discPct item =
  case not item.discounted && item.qty >= minQty of
    True ->
      { item | price = item.price * (1.0 - discPct)
              , discounted = True
      }
    False ->
      item

newCart : List Item
newCart =
  List.map ((discount 10 0.3) >> (discount 5 0.2)) cart

type alias AnotherItem =
  { name : String
  , qty : Int
  , freeQty : Int
  }

anotherCart : List AnotherItem
anotherCart =
  [ { name = "Lemon", qty = 1, freeQty = 0 }
  , { name = "Apple", qty = 5, freeQty = 0 }
  , { name = "Pear", qty = 10, freeQty = 0 }
  ]

free : Int -> List AnotherItem -> List AnotherItem
free purchase item =
  if purchase >= 5 && purchase < 10 then
    item
    |> List.filter (\n -> n.qty >= purchase)
    |> List.map (\n -> {n | freeQty = 1})
  else if purchase >= 10 && purchase > 5 then
    item
    |> List.filter (\n -> n.qty >= purchase)
    |> List.map (\n -> {n | freeQty = 3})
  else
    item

free2 : Int -> Int -> AnotherItem -> AnotherItem
free2 minQty freeQty item =
  case item.freeQty == 0 && minQty > 0 of
    True ->
      { item | freeQty = item.qty // minQty * freeQty }
    False ->
      item
--}

module Sample exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- Main


main =
  Browser.sandbox { init = init
                  , update = update
                  , view = view
                  }


-- Model


type alias Model =
  { calories : Int
  , input : Int
  , error : Maybe String
  }

init : Model
init =
  Model 0 0 Nothing



-- Update


type Msg
  = AddCalories
  | ReduceCalories
  | Input String
  | Clear

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddCalories ->
      { model | calories = model.calories + model.input
              , input = 0 }
    ReduceCalories ->
      { model | calories = model.calories - model.input
              , input = 0 }
    Input value ->
      case String.toInt value of
        Just num ->
          { model | input = num
                  , error = Nothing }
        Nothing ->
          { model | input = 0
                  , error = Just "only int numbers allowed" }
    Clear ->
      init



-- View


view : Model -> Html Msg
view model =
  div []
    [ h3 []
        [ text ("Calories: " ++ (String.fromInt model.calories)) ]
    , input [ type_ "text"
            , placeholder "Enter calories here"
            , onInput Input
            , value ( if model.input == 0 then
                        ""
                      else
                        String.fromInt model.input)]
        []
    , div []
        [ text (Maybe.withDefault "" model.error) ]
    , button [ type_ "button" , onClick AddCalories]
        [ text "Add" ]
    , button [ type_ "button" , onClick ReduceCalories]
        [ text "Reduce" ]
    , button [ type_ "button" , onClick Clear]
        [ text "Clear" ]
    , h1 []
        [ text (String.fromInt model.input) ]
    ]

