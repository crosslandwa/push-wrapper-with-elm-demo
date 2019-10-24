module Tests exposing (..)

import Test exposing (..)
import Expect
import GameOfLife
import Grid
import SimpleBlues
import SneakyGreens

all : Test
all =
  describe "WAC Machine"
    [ describe "Simple blues"
      [ test "LEDs are off initially and are toggled on/off by subsequent grid presses" <|
        \_ ->
          let
            applyGridPressToFirstElementTimes : Int -> GridButton.GridButton msg
            applyGridPressToFirstElementTimes n =
              List.range 1 n
                |> List.foldl (\i model -> SimpleBlues.update 0 model) SimpleBlues.initModel
                |> SimpleBlues.gridButton 0
          in
            List.range 0 5
              |> List.map applyGridPressToFirstElementTimes
              |> Expect.equal [GridButton.off, GridButton.blue, GridButton.off, GridButton.blue, GridButton.off, GridButton.blue]
      ]
    , describe "Sneaky greens"
      [ test "LEDs are off initially and move through red/green/off on subsequent grid presses" <|
        \_ ->
          let
            -- use recursion instead of List.foldl to see how both approaches look
            applyGridPressToFirstElement i model =
              if i <= 0 then
                model
              else
                applyGridPressToFirstElement (i - 1) (SneakyGreens.update 0 model)
            applyGridPressToFirstElementTimes : Int -> GridButton.GridButton msg
            applyGridPressToFirstElementTimes n =
              SneakyGreens.gridButton 0 (applyGridPressToFirstElement n SneakyGreens.initModel)
          in
            List.range 0 5
              |> List.map applyGridPressToFirstElementTimes
              |> Expect.equal [GridButton.off, GridButton.red, GridButton.green, GridButton.off, GridButton.red, GridButton.green]
      ]
    , describe "Game of life"
      [ test "all cells are initially off and can be toggled on/off with presses" <|
        \_ ->
          let
            isCellAliveAfterBeingToggledTimes : Int -> Int -> Int -> Bool
            isCellAliveAfterBeingToggledTimes x y n =
              List.range 1 n
                |> List.foldl (\i model -> GameOfLife.toggleCell x y model) GameOfLife.initModel
                |> GameOfLife.isAlive x y
          in
            List.range 0 3
              |> List.map (isCellAliveAfterBeingToggledTimes 0 0)
              |> Expect.equal [False, True, False, True]
      , test "a dead cell with 0 alive neighbours stays dead after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal False
      , test "a dead cell with 1 alive neighbours stays dead after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal False
      , test "a dead cell with 2 alive neighbours stays dead after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.toggleCell 0 1
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal False
      , test "a dead cell with 3 alive neighbours is alive after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.toggleCell 0 1
            |> GameOfLife.toggleCell 1 1
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal True
      , test "a live cell with 0 alive neighbours is dead after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 0 0
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal False
      , test "a live cell with 1 alive neighbours is dead after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 0 0
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal False
      , test "a live cell with 2 alive neighbours is alive after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 0 0
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.toggleCell 0 1
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal True
      , test "a live cell with 3 alive neighbours is alive after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 0 0
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.toggleCell 0 1
            |> GameOfLife.toggleCell 1 1
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 0 0
            |> Expect.equal True
      , test "a live cell with 4 alive neighbours is alive after evolution" <|
        \_ ->
          GameOfLife.initModel
            |> GameOfLife.toggleCell 1 1
            |> GameOfLife.toggleCell 0 0
            |> GameOfLife.toggleCell 0 1
            |> GameOfLife.toggleCell 0 2
            |> GameOfLife.toggleCell 1 0
            |> GameOfLife.evolve
            |> GameOfLife.isAlive 1 1
            |> Expect.equal False
      ]
    ]
