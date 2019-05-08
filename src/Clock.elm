module Main exposing (..)

import Browser
import Html exposing (..)
import Task
import Time exposing (Posix, Zone, toHour, toMinute, toSecond)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = Loading
    | GotZone Zone
    | WithTime CurrentTime


type alias CurrentTime =
    { zone : Zone
    , time : Posix
    }


type Msg
    = GetZone Zone
    | Tick Posix
    | NoOp Posix


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Task.perform GetZone Time.here )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )

        GetZone zone ->
            case model of
                Loading ->
                    ( GotZone zone, Cmd.none )

                GotZone _ ->
                    ( GotZone zone, Cmd.none )

                WithTime ct ->
                    ( WithTime { ct | zone = zone }
                    , Cmd.none
                    )

        Tick time ->
            case model of
                Loading ->
                    ( model, Cmd.none )

                GotZone zone ->
                    ( WithTime { zone = zone, time = time }
                    , Cmd.none
                    )

                WithTime ct ->
                    ( WithTime { ct | time = time }
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loading ->
            -- Sub.none
            Time.every 1 NoOp

        _ ->
            Time.every 1000 Tick


view : Model -> Html Msg
view model =
    case model of
        WithTime ct ->
            viewTime ct

        _ ->
            h1 [] [ text "Loading..." ]


viewTime : CurrentTime -> Html Msg
viewTime { zone, time } =
    List.map (\f -> f zone time) [ toHour, toMinute, toSecond ]
        |> List.map String.fromInt
        |> String.join " : "
        |> (\t -> h1 [] [ text t ])
