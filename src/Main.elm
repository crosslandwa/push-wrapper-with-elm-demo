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
  = GridSelectButtonPressed Int
  | GameOfLifeGridAdaptorMsg GameOfLifeGridAdaptor.Msg
  | SimpleBluesMsg SimpleBlues.Msg
  | SneakyGreensMsg SneakyGreens.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( case msg of
      GameOfLifeGridAdaptorMsg nestedMsg ->
        { model | gameOfLife = GameOfLifeGridAdaptor.update nestedMsg model.gameOfLife }
      GridSelectButtonPressed x ->
        { model | appLayer =
          case model.appLayer of
            ShowSimpleBlues -> ShowSneakyGreens
            ShowSneakyGreens -> ShowGameOfLifeGridAdaptor
            ShowGameOfLifeGridAdaptor -> ShowSimpleBlues
        }
      SimpleBluesMsg nestedMsg ->
        { model | blues = SimpleBlues.update nestedMsg model.blues }
      SneakyGreensMsg nestedMsg ->
        { model | greens = SneakyGreens.update nestedMsg model.greens }
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

gridButton : Int -> Int -> Model -> GridButton Msg
gridButton x y model =
  case model.appLayer of
    ShowSimpleBlues ->
      GridButton.map SimpleBluesMsg (SimpleBlues.gridButton x y model.blues)
    ShowSneakyGreens ->
      GridButton.map SneakyGreensMsg (SneakyGreens.gridButton x y model.greens)
    ShowGameOfLifeGridAdaptor ->
      GridButton.map GameOfLifeGridAdaptorMsg (GameOfLifeGridAdaptor.gridButton x y model.gameOfLife)

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
          GridButton.toHtml (gridButton x y model)
      ) (List.range 0 63))
    ]


---- SUBSCRIPIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
      [ Ports.hardwareGridButtonPressed (\{x, y, velocity} ->
          case model.appLayer of
            ShowSimpleBlues ->
              SimpleBluesMsg (SimpleBlues.gridButtonPressed x y)
            ShowSneakyGreens ->
              SneakyGreensMsg (SneakyGreens.gridButtonPressed x y)
            ShowGameOfLifeGridAdaptor ->
              GameOfLifeGridAdaptorMsg (GameOfLifeGridAdaptor.gridButtonPressed x y)
        )
      , Ports.hardwareGridSelectButtonPressed (\{x} -> GridSelectButtonPressed x)
      , Sub.map GameOfLifeGridAdaptorMsg (GameOfLifeGridAdaptor.subscriptions (model.appLayer == ShowGameOfLifeGridAdaptor))
      ]

---- PROGRAM ----

main : Program () Model Msg
main =
  Browser.element
    { view = view
    , init = \_ -> init
    , update = update
    , subscriptions = subscriptions
    }
