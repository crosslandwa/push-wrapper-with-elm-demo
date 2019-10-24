module Main exposing (..)

import Browser
import GameOfLifeGridAdaptor
import GridButton exposing (GridButton)
import GridSelectButton exposing (GridSelectButton)
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
  | GridSelectButtonPressed Int

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
    GridSelectButtonPressed x ->
      toggleAppLayer model
    GridButtonPressed x y ->
      let
        index = y * 8 + x
      in
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

gridSelectButton : Model -> GridSelectButton msg
gridSelectButton m =
  case m.appLayer of
    ShowSimpleBlues ->
      GridSelectButton.blue
    ShowSneakyGreens ->
      GridSelectButton.green
    ShowGameOfLifeGridAdaptor ->
      GridSelectButton.red

gridButton : Int -> Model -> GridButton msg
gridButton index model =
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
    , div
      [ class "wac-grid-select"]
      (List.map (\x -> (gridSelectButton model) x (GridSelectButtonPressed x)) (List.range 0 7))
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
