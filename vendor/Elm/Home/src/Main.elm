module Main exposing (..)

import Browser
import Html exposing (Html, button, div, hr, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import List


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { flags = flags
      , cnt = 0
      }
    , Cmd.none
    )


type alias Flags =
    { a : Int, be : String }


type alias Model =
    { flags : Flags
    , cnt : Int
    }


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
        , div [] [ text (Debug.toString model) ]
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
