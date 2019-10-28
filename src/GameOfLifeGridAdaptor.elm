module GameOfLifeGridAdaptor exposing (Model, Msg, initModel, gridButton, gridButtonPressed, subscriptions, update)

import Array exposing (Array)
import GridButton exposing (GridButton)
import GameOfLife
import Time

type Model
 = Model GameOfLife.Model

type Msg
 = Evolve Time.Posix
 | GridButtonPressed Int Int

initModel : Model
initModel =
  Model (GameOfLife.initModel)

gridButton : Int -> Int -> Model -> GridButton Msg
gridButton x y (Model model) =
  if (GameOfLife.isAlive x y model) then
    GridButton.red x y (GridButtonPressed x y)
  else
    GridButton.off x y (GridButtonPressed x y)

update : Msg -> Model -> Model
update msg (Model model) =
  case msg of
    Evolve _ ->
      Model (GameOfLife.evolve model)
    GridButtonPressed x y ->
      Model (GameOfLife.toggleCell x y model)

gridButtonPressed : Int -> Int -> Msg
gridButtonPressed x y =
  GridButtonPressed x y

subscriptions : Bool -> Sub Msg
subscriptions isActive =
  case isActive of
    True -> Time.every 200 Evolve
    False -> Sub.none
