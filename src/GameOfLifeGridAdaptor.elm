module GameOfLifeGridAdaptor exposing (Model, initModel, gridButton, update)

import Array exposing (Array)
import Grid
import GameOfLife

type Model
 = Model (GameOfLife.Model)

initModel : Model
initModel =
  Model (GameOfLife.initModel)

gridButton : Int -> Model -> Grid.GridButton msg
gridButton index (Model model) =
  let
    x = modBy 8 index
    y = index // 8
  in
    if (x == 0 || x == 7 || y == 0 || y == 7) then
      Grid.off
    else if (GameOfLife.isAlive (x - 1) (y - 1) model) then
      Grid.red
    else
      Grid.off

update : Int -> Model -> Model
update index (Model model) =
  let
    x = modBy 8 index
    y = index // 8
  in
    if (x == 0 || x == 7 || y == 0 || y == 7) then
      Model (GameOfLife.evolve model)
    else
      Model (GameOfLife.toggleCell (x - 1) (y - 1) model)
