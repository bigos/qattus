module Main exposing (..)

import Browser
import Html exposing (Html, button, div, hr, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init () =
    ( { cnt = 0 }, Cmd.none )


type alias Model =
    { cnt : Int }


type alias Text =
    { id : String
    , link : String
    , body : String
    }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            ( { model | cnt = model.cnt + 1 }, Cmd.none )

        Decrement ->
            ( { model | cnt = model.cnt - 1 }, Cmd.none )


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , span [ class <| counterClasses model ] [ text (String.fromInt model.cnt) ]
        , button [ onClick Increment ] [ text "+" ]
        , hr [] []
        ]


counterClasses model =
    let
        counterValue =
            model.cnt

        counterColorClass =
            if counterValue >= 0 then
                "positive"

            else
                "negative"

        counterClasses2 =
            String.join " " [ "counter", counterColorClass ]
    in
    counterClasses2


subscriptions model =
    Sub.none
