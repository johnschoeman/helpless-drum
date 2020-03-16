module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Model =
    { name : String
    }


init : ( Model, Cmd Msg )
init =
    ( { name = "Steve the helpless drum"
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ButtonClicked
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ButtonClicked ->
            let
                nextName =
                    model.name ++ "m"
            in
            ( { model | name = nextName }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text model.name ]
        , button [ class "red-button", onClick ButtonClicked ] [ text "+" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
