module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, img, text)
import Html.Attributes exposing (class, src, style)
import Html.Events exposing (onClick)
import Svg exposing (rect, svg)
import Svg.Attributes exposing (..)
import Time



---- MODEL ----


type alias Model =
    { gameStep : Int
    , board : Board
    }


type alias Board =
    List (List BoardCell)


type alias BoardCell =
    { coordinate : Coordinate
    , entity : Entity
    }


type alias Coordinate =
    ( Int, Int )


type Entity
    = Drum
    | Beer


showEntity : Entity -> String
showEntity entity =
    case entity of
        Drum ->
            "Drum"

        Beer ->
            "Beer"


makeCooridinate : Int -> Coordinate
makeCooridinate i =
    ( i, i )


init : ( Model, Cmd Msg )
init =
    ( { gameStep = 0
      , board = initialBoard
      }
    , Cmd.none
    )


initialBoard : Board
initialBoard =
    [ [ BoardCell ( 0, 0 ) Drum, BoardCell ( 0, 1 ) Beer ]
    , [ BoardCell ( 1, 0 ) Beer, BoardCell ( 1, 1 ) Beer ]
    ]



---- UPDATE ----


type Msg
    = Tick Time.Posix
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            let
                nextGameStep =
                    model.gameStep + 1
            in
            ( { model | gameStep = nextGameStep }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text <| String.fromInt model.gameStep ]
        , drawBoard model.board
        ]


drawBoard : Board -> Html msg
drawBoard board =
    div []
        [ svg
            [ width "600", height "600", viewBox "0 0 600 600" ]
            (foo board)
        ]


foo : List (List BoardCell) -> List (Svg.Svg msg)
foo board =
    let
        flattenedList =
            List.concat board
    in
    List.map drawBoardCell flattenedList


drawBoardCell : BoardCell -> Svg.Svg msg
drawBoardCell { coordinate, entity } =
    drawRect (coordinateToGameSpace coordinate) entity


coordinateToGameSpace : Coordinate -> ( Int, Int )
coordinateToGameSpace ( x, y ) =
    ( x * 450, y * 450 )


drawRect : Coordinate -> Entity -> Svg.Svg msg
drawRect coord entity =
    case entity of
        Drum ->
            rect (svgCoordinate coord ++ [ width "100", height "100", rx "15", ry "15", stroke "red", fill "red" ]) []

        Beer ->
            rect (svgCoordinate coord ++ [ width "100", height "100", rx "30", ry "30" ]) []


drum : Model -> Html msg
drum { gameStep } =
    let
        coordinate =
            makeCooridinate gameStep
    in
    svg
        [ width "600", height "600", viewBox "0 0 600 600" ]
        [ rect (svgCoordinate coordinate ++ [ width "100", height "100", rx "15", ry "15" ]) [] ]


svgCoordinate : Coordinate -> List (Svg.Attribute msg)
svgCoordinate ( xInt, yInt ) =
    let
        xVal =
            String.fromInt xInt

        yVal =
            String.fromInt yInt
    in
    [ Svg.Attributes.x xVal, y yVal ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (1 * 1000) Tick



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
