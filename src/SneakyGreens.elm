module SneakyGreens exposing (Model, gridButton, initModel, update)

import Array exposing (Array)
import GridButton exposing (GridButton)

type Model
 = Model (Array TriState)

initModel : Model
initModel =
  Model (Array.repeat 64 A)

type TriState
  = A
  | B
  | C

rotateState : TriState -> TriState
rotateState triState =
  case triState of
    A ->
      B
    B ->
      C
    C ->
      A

update : Int -> Model -> Model
update index (Model values) =
  Model (Array.indexedMap (\i x -> if i == index then rotateState x else x) values)

gridButton : Int -> Int -> Model -> (msg -> GridButton msg)
gridButton x y model =
  case model of
    Model values ->
      case Maybe.withDefault A (Array.get (x + y * 8) values) of
        A ->
          GridButton.off x y
        B ->
          GridButton.red x y
        C ->
          GridButton.green x y
