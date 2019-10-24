module GameOfLifeGridAdaptor exposing (Model, evolve, initModel, gridButton, subscriptions, update)

import Array exposing (Array)
import GridButton
import GameOfLife
import Time

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
    if (GameOfLife.isAlive x y model) then
      GridButton.red
    else
      GridButton.off

update : Int -> Model -> Model
update index (Model model) =
  let
    x = modBy 8 index
    y = index // 8
  in
    Model (GameOfLife.toggleCell x y model)

evolve : Model -> Model
evolve (Model model) =
  Model (GameOfLife.evolve model)

subscriptions : Bool -> msg -> Sub msg
subscriptions isActive msg =
  case isActive of
    True -> Time.every 200 (\_ -> msg)
    False -> Sub.none
