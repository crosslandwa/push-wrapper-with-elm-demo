module Tests exposing (..)

import Test exposing (..)
import Expect
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
            applyGridPressToFirstElementTimes : Int -> Grid.GridButton msg
            applyGridPressToFirstElementTimes n =
              List.range 1 n
                |> List.foldl (\i model -> SimpleBlues.update 0 model) SimpleBlues.initModel
                |> SimpleBlues.gridButton 0
          in
            List.range 0 5
              |> List.map applyGridPressToFirstElementTimes
              |> Expect.equal [Grid.off, Grid.blue, Grid.off, Grid.blue, Grid.off, Grid.blue]
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
            applyGridPressToFirstElementTimes : Int -> Grid.GridButton msg
            applyGridPressToFirstElementTimes n =
              SneakyGreens.gridButton 0 (applyGridPressToFirstElement n SneakyGreens.initModel)
          in
            List.range 0 5
              |> List.map applyGridPressToFirstElementTimes
              |> Expect.equal [Grid.off, Grid.red, Grid.green, Grid.off, Grid.red, Grid.green]
      ]
    ]
