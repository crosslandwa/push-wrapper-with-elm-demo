module SneakyGreens exposing (Model, gridButton, initModel, update)

import Array exposing (Array)
import Grid

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

gridButton : Int -> Model -> Grid.GridButton msg
gridButton index model =
  case model of
    Model values ->
      case Maybe.withDefault A (Array.get index values) of
        A ->
          Grid.off
        B ->
          Grid.red
        C ->
          Grid.green
