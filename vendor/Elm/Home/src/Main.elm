module Main exposing (..)

import Browser
import Html exposing (Html, button, div, hr, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, map3, string)
import List


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , cnt = 0
      , result = ""
      }
    , Http.get
        { url = "http://localhost:3000/texts.json"
        , expect = Http.expectString GotTextString
        }
    )


type alias Flags =
    { a : Int, be : String }


type alias Model =
    { flags : Flags
    , cnt : Int
    , result : String
    }


type alias Text =
    { id : String
    , link : String
    , body : String
    }


type Msg
    = Increment
    | Decrement
    | GotTextString (Result Http.Error String)
    | GotText (Result Http.Error Text)


update msg model =
    case msg of
        Increment ->
            ( { model
                | cnt = model.cnt + 1
                , result = ""
              }
            , Cmd.none
            )

        Decrement ->
            ( { model | cnt = model.cnt - 1 }, getTexts )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | result = Debug.toString fullText }, Cmd.none )

                Err err ->
                    ( { model | result = Debug.toString err }, Cmd.none )

        GotTextString result ->
            case result of
                Ok fullText ->
                    ( { model | result = fullText }, Cmd.none )

                Err err ->
                    ( { model | result = Debug.toString err }, Cmd.none )


host =
    "http://localhost:3000"


getTexts =
    Http.get { url = host ++ "/texts.json", expect = Http.expectJson GotText gotTextDecoder }


gotTextDecoder : Decoder Text
gotTextDecoder =
    map3 Text
        (field "id" string)
        (field "link" string)
        (field "body" string)


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
