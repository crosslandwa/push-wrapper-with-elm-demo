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

type alias Coordinate = { x: Int, y: Int, index: Int }

coordFromIndex index =
  coordFromXY (modBy 6 index) (index // 6)

coordFromXY x y =
  { x = x, y = y, index = x + y * 6 }

relativeCoordinate : Int -> Int -> Coordinate -> Maybe Coordinate
relativeCoordinate dx dy coord =
  let
    x = coord.x + dx
    y = coord.y + dy
  in
    if (x >= 0) && (x <= 5) && (y >= 0) && (y <= 5) then
      Just (coordFromXY x y)
    else
      Nothing

cellStateAt : Coordinate -> Model -> CellState
cellStateAt c (Model cells) =
  Maybe.withDefault Dead (Array.get c.index cells)

isAlive : Int -> Int -> Model -> Bool
isAlive x y model =
  Alive == cellStateAt (coordFromXY x y) model

toggleCell : Int -> Int -> Model -> Model
toggleCell x y model =
  let
    coord = coordFromXY x y
    toggle cellState =
      case cellState of
        Dead ->
          Alive
        Alive ->
          Dead
  in
    nextModel (\i cell -> if i == coord.index then toggle cell else cell) model

nextModel : (Int -> CellState -> CellState) -> Model -> Model
nextModel transform (Model cells) =
  Model (Array.indexedMap transform cells)

evolve : Model -> Model
evolve model =
  nextModel
    (\i cellState -> neighbourStatesFor (coordFromIndex i) model |> evolveCell cellState)
    model

neighbourStatesFor coord model =
  let
    possibleNeighbourCoordinates = List.map
      (\(dx, dy) -> relativeCoordinate dx dy coord)
      [ (-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1) ]
    filterNothings values =
      List.filterMap identity values
  in
    possibleNeighbourCoordinates
      |> filterNothings
      |> List.map (\(c) -> cellStateAt c model)

evolveCell : CellState -> List CellState -> CellState
evolveCell currentState neighbourStates =
  let
    livingNeighbours = List.length <| List.filter (\state -> state == Alive) neighbourStates
  in
    if (livingNeighbours == 3) || (livingNeighbours == 2 && currentState == Alive) then
      Alive
    else
      Dead
