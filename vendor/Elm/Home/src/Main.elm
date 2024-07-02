module Main exposing (..)

import Browser
import Element exposing (Element, alignRight, centerY, el, fill, padding, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html, button, div, hr, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import String.Interpolate exposing (..)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        premodel =
            { flags = flags
            , cnt = 0
            , result = ""
            }
    in
    ( premodel
    , getText premodel
    )


type alias Flags =
    { a : Int
    , be : String
    , base_url : String
    }


type alias Model =
    { flags : Flags
    , cnt : Int
    , result : String
    }


type alias Text =
    { id : Int
    , title : String
    , link : String
    , body : String
    , created_at : String
    , updated_at : String
    }


type Msg
    = Increment
    | Decrement
    | GotTextString (Result Http.Error String)
    | GotTextList (Result Http.Error (List Text))
    | GotTextRecord (Result Http.Error Text)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model
                | cnt = model.cnt + 1
                , result = ""
              }
            , getTextRecord model
            )

        Decrement ->
            ( { model | cnt = model.cnt - 1 }, getTextsList model )

        GotTextRecord result ->
            case result of
                Ok fullText ->
                    Debug.log ("got the correctly parsed json object" ++ Debug.toString fullText)
                        ( { model | result = Debug.toString fullText }, Cmd.none )

                Err err ->
                    ( { model | result = "got text error " ++ Debug.toString err }, Cmd.none )

        GotTextList result ->
            case result of
                Ok fullText ->
                    Debug.log ("got the correctly parsed json list " ++ Debug.toString fullText)
                        ( { model | result = Debug.toString fullText }, Cmd.none )

                Err err ->
                    ( { model | result = "got text list error " ++ Debug.toString err }, Cmd.none )

        GotTextString result ->
            case result of
                Ok fullText ->
                    ( { model | result = fullText }, Cmd.none )

                Err err ->
                    ( { model | result = "got string of text error" ++ Debug.toString err }, Cmd.none )


host : Model -> String
host model =
    model.flags.base_url


getTextsList : Model -> Cmd Msg
getTextsList model =
    Http.get
        { url =
            interpolate "{0}/texts.json" [ host model ]
        , expect = Http.expectJson GotTextList gotTextsDecoder
        }


getTextRecord : Model -> Cmd Msg
getTextRecord model =
    let
        id =
            "3"
    in
    Http.get
        { url = interpolate "{0}/texts/{1}.json" [ host model, id ]
        , expect = Http.expectJson GotTextRecord gotTextDecoder
        }


getText : Model -> Cmd Msg
getText model =
    Http.get
        { url = interpolate "{0}/texts.json" [ host model ]
        , expect = Http.expectString GotTextString
        }


gotTextsDecoder : Decoder (List Text)
gotTextsDecoder =
    list gotTextDecoder


gotTextDecoder : Decoder Text
gotTextDecoder =
    Decode.succeed Text
        |> required "id" int
        |> required "title" string
        |> required "link" string
        |> required "body" string
        |> required "created_at" string
        |> required "updated_at" string


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ Html.text "-" ]
        , span [ class <| counterClasses model ] [ Html.text (String.fromInt model.cnt) ]
        , button [ onClick Increment ] [ Html.text "+" ]
        , hr [] []
        , Element.layout [] myRowOfStuff
        , hr [] []
        , div [] [ Html.text (Debug.toString model) ]
        ]


myRowOfStuff : Element msg
myRowOfStuff =
    row [ width fill, centerY, spacing 30 ]
        [ myElement "on1"
        , myElement "2two"
        , el [ Element.explain Debug.todo ] (myElement "three3")
        ]


myElement : String -> Element msg
myElement str =
    el
        [ Background.color (rgb255 40 0 245)
        , Font.color (rgb255 255 255 255)
        , Border.rounded 3
        , padding 30
        ]
        (Element.text str)


counterClasses : Model -> String
counterClasses model =
    let
        counterValue =
            model.cnt

        counterColorClass =
            if counterValue >= 0 then
                "positive"

            else
                "negative"
    in
    String.join " " [ "counter", counterColorClass ]


subscriptions _ =
    Sub.none
