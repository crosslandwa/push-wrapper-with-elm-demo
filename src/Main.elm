module Main exposing (..)

import Browser
import GameOfLifeGridAdaptor
import GridButton exposing (GridButton)
import Ports
import SimpleBlues
import SneakyGreens
import Html exposing (Html, text, div, h1)
import Html.Attributes exposing (class)
import Html.Events

---- MODEL ----


type alias Model =
  { blues: SimpleBlues.Model
  , gameOfLife: GameOfLifeGridAdaptor.Model
  , greens: SneakyGreens.Model
  , appLayer: AppLayer
  }

type AppLayer
  = ShowSimpleBlues
  | ShowSneakyGreens
  | ShowGameOfLifeGridAdaptor

init : ( Model, Cmd Msg )
init =
  (
  { blues = SimpleBlues.initModel
  , gameOfLife = GameOfLifeGridAdaptor.initModel
  , greens = SneakyGreens.initModel
  , appLayer = ShowSimpleBlues
  }, Cmd.none )



---- UPDATE ----

type Msg
  = GridButtonPressed Int Int

toggleAppLayer : Model -> (Model, Cmd Msg)
toggleAppLayer model =
  (
    { model | appLayer =
      if model.appLayer == ShowSimpleBlues then
        ShowSneakyGreens
      else if model.appLayer == ShowSneakyGreens then
        ShowGameOfLifeGridAdaptor
      else
        ShowSimpleBlues
    }
    , Cmd.none
  )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GridButtonPressed x y ->
      let
        index = y * 8 + x
      in
        case index of
          0 ->
            toggleAppLayer model
          7 ->
            toggleAppLayer model
          56 ->
            toggleAppLayer model
          63 ->
            toggleAppLayer model
          _ ->
            case model.appLayer of
              ShowSimpleBlues ->
                (
                  { model | blues = SimpleBlues.update index model.blues }
                  , Cmd.none
                )
              ShowSneakyGreens ->
                (
                  { model | greens = SneakyGreens.update index model.greens }
                  , Cmd.none
                )
              ShowGameOfLifeGridAdaptor ->
                (
                  { model | gameOfLife = GameOfLifeGridAdaptor.update index model.gameOfLife }
                  , Cmd.none
                )


---- VIEW ----

appLayerGridButton : Model -> GridButton msg
appLayerGridButton m =
  case m.appLayer of
    ShowSimpleBlues ->
      GridButton.blue
    ShowSneakyGreens ->
      GridButton.green
    ShowGameOfLifeGridAdaptor ->
      GridButton.red

gridButton : Int -> Model -> GridButton msg
gridButton index model =
  case index of
    0 ->
      appLayerGridButton model
    7 ->
      appLayerGridButton model
    56 ->
      appLayerGridButton model
    63 ->
      appLayerGridButton model
    _ ->
      case model.appLayer of
        ShowSimpleBlues ->
          SimpleBlues.gridButton index model.blues
        ShowSneakyGreens ->
          SneakyGreens.gridButton index model.greens
        ShowGameOfLifeGridAdaptor ->
          GameOfLifeGridAdaptor.gridButton index model.gameOfLife

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "WAC machine" ]
    , div [ class "wac-grid"]
      (List.map (\i ->
        let
          x = modBy 8 i
          y = i // 8
        in
          (gridButton i model) x y (GridButtonPressed x y)
      ) (List.range 0 63))
    ]


---- SUBSCRIPIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.hardwareGridButtonPressed (\{x, y, velocity} -> GridButtonPressed x y)

---- PROGRAM ----

main : Program () Model Msg
main =
  Browser.element
    { view = view
    , init = \_ -> init
    , update = update
    , subscriptions = subscriptions
    }
