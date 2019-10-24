module GameOfLifeGridAdaptor exposing (Model, initModel, gridButton, update)

import Array exposing (Array)
import GridButton
import GameOfLife

type Model
 = Model (GameOfLife.Model)

initModel : Model
initModel =
  Model (GameOfLife.initModel)

gridButton : Int -> Model -> GridButton.GridButton msg
gridButton index (Model model) =
  let
    x = modBy 8 index
    y = index // 8
  in
    if (x == 0 || x == 7 || y == 0 || y == 7) then
      GridButton.off
    else if (GameOfLife.isAlive (x - 1) (y - 1) model) then
      GridButton.red
    else
      GridButton.off

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
