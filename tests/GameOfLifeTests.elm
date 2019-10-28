module GameOfLifeTests exposing (..)

import Test exposing (..)
import Expect
import GameOfLife

all : Test
all =
  describe "Game of life"
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
