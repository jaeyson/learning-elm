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
    { nicknames : List String
    , errorMessage : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { nicknames = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )



-- Update


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, getText )

        DataReceived (Ok nicknameStr) ->
            let
                nicknames =
                    String.split "," nicknameStr
            in
            ( { model
                | nicknames = nicknames
              }
            , Cmd.none
            )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (createErrorMessage httpError)
              }
            , Cmd.none
            )



{--
things to take note about Http.Error message:

type alias Metadata

type Response body

Http.expectStringResponse
--}


{--}
createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            String.fromInt response

        Http.BadBody message ->
            message


{--}
getText =
    Http.get
        { url = "http://localhost:8006/old-school.txt"
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
        , viewNicknamesOrError model
        ]


viewNicknamesOrError : Model -> Html Msg
viewNicknamesOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewNicknames model.nicknames


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "couldn't fetch nicknames at this time"
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewNicknames : List String -> Html Msg
viewNicknames nicknames =
    div []
        [ h3 []
            [ text "old school main characters" ]
        , ul []
            (List.map viewNickname nicknames)
        ]


viewNickname : String -> Html Msg
viewNickname nickname =
    li [] [ text nickname ]
