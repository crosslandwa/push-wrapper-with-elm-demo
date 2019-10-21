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
            applyGridPressToFirstElement i model =
              SimpleBlues.update 0 model
            firstElementToLED model =
              SimpleBlues.gridButton 0 model
            applyGridPressToFirstElementTimes : Int -> Grid.GridButton msg
            applyGridPressToFirstElementTimes n =
              firstElementToLED (List.foldl applyGridPressToFirstElement SimpleBlues.initModel (List.range 1 n))
          in
            Expect.equal
              [Grid.off, Grid.blue, Grid.off, Grid.blue, Grid.off, Grid.blue]
              (List.map applyGridPressToFirstElementTimes (List.range 0 5))
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
            Expect.equal
              [Grid.off, Grid.red, Grid.green, Grid.off, Grid.red, Grid.green]
              (List.map applyGridPressToFirstElementTimes (List.range 0 5))
      ]
    ]
