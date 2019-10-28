module SneakyGreens exposing (Model, Msg, TriState(..), elementState, gridButton, gridButtonPressed, initModel, update)

import Array exposing (Array)
import GridButton exposing (GridButton)

type Model
 = Model (Array TriState)


type Msg
 = Rotate Int


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
    A -> B
    B -> C
    C -> A


update : Msg -> Model -> Model
update msg (Model values) =
  case msg of
    Rotate index ->
      Model (Array.indexedMap (\i x -> if i == index then rotateState x else x) values)


indexFrom x y =
  x + y * 8


gridButton : Int -> Int -> Model -> GridButton Msg
gridButton x y model =
  let
    index = indexFrom x y
    msg = Rotate index
  in
    case elementState index model of
      A ->
        GridButton.off x y msg
      B ->
        GridButton.red x y msg
      C ->
        GridButton.green x y msg


gridButtonPressed : Int -> Int -> Msg
gridButtonPressed x y =
  Rotate (indexFrom x y)


elementState : Int -> Model -> TriState
elementState index (Model values) =
  Maybe.withDefault A (Array.get index values)
