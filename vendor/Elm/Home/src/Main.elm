module Main exposing (..)

import Browser
import Html exposing (Html, button, div, hr, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, list, map3, map4, map6, map7, string)
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
    , getText
    )


type alias Flags =
    { a : Int, be : String }


type alias Model =
    { flags : Flags
    , cnt : Int
    , result : String
    }


type alias Text =
    { id : Int
    , link : String
    , title : String
    , body : String
    , created_at : String
    , updated_at : String
    }


type Msg
    = Increment
    | Decrement
    | GotTextString (Result Http.Error String)
    | GotText (Result Http.Error (List Text))


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
                    Debug.log ("got the correctly parsed json " ++ Debug.toString fullText)
                        ( { model | result = Debug.toString fullText }, Cmd.none )

                Err err ->
                    ( { model | result = "got text error " ++ Debug.toString err }, Cmd.none )

        GotTextString result ->
            case result of
                Ok fullText ->
                    ( { model | result = fullText }, Cmd.none )

                Err err ->
                    ( { model | result = "got string of text error" ++ Debug.toString err }, Cmd.none )


host =
    "http://localhost:3000"


getTexts =
    Http.get { url = host ++ "/texts.json", expect = Http.expectJson GotText gotTextsDecoder }


getText =
    Http.get { url = host ++ "/texts.json", expect = Http.expectString GotTextString }


gotTextsDecoder : Decoder (List Text)
gotTextsDecoder =
    list gotTextDecoder


gotTextDecoder : Decoder Text
gotTextDecoder =
    map6 Text
        (field "id" int)
        (field "title" string)
        (field "body" string)
        (field "link" string)
        (field "created_at" string)
        (field "updated_at" string)


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
