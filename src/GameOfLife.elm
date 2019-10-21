module GameOfLife exposing (Model, evolve, initModel, isAlive, toggleCell)

import Array exposing (Array)

type CellState
  = Dead
  | Alive

type Model
 = Model (Array CellState)

initModel : Model
initModel =
  Model (Array.repeat 36 Dead)

toggle : CellState -> CellState
toggle current =
  case current of
    Dead ->
      Alive
    Alive ->
      Dead

update : Int -> Model -> Model
update index (Model values) =
  Model (Array.indexedMap (\i x -> if i == index then toggle x else x) values)

indexFrom : Int -> Int -> Int
indexFrom x y =
  x + y * 6

isAlive : Int -> Int -> Model -> Bool
isAlive x y model =
  case model of
    Model values ->
      Alive == Maybe.withDefault Dead (Array.get (indexFrom x y) values)

toggleCell : Int -> Int -> Model -> Model
toggleCell x y model =
  update (indexFrom x y) model

evolve : Model -> Model
evolve model =
  case model of
    (Model values) ->
      Model (Array.indexedMap (\i cell -> evolveCell cell (neighbourStatesFor i model)) values)

neighbourStatesFor index (Model values) =
  let
    x = modBy 6 index
    y = index // 6
    neighbourLocations = List.filter
      (\(xx, yy) -> (xx >= 0) && (xx <= 5) && (yy >= 0) && (yy <= 5))
      [ (x - 1, y - 1), (x, y - 1), (x + 1, y - 1)
      , (x - 1, y), (x + 1, y)
      , (x - 1, y + 1), (x, y + 1), (x + 1, y + 1)
      ]
  in
    List.map (\(xxx, yyy) -> Maybe.withDefault Dead (Array.get (indexFrom xxx yyy) values)) neighbourLocations

evolveCell : CellState -> List CellState -> CellState
evolveCell state neighbourStates =
  let
    livingNeighbours = (List.length <| List.filter (\x -> x == Alive) neighbourStates)
  in
    if livingNeighbours == 3 then
      Alive
    else if livingNeighbours == 2 && state == Alive then
      Alive
    else
      Dead
