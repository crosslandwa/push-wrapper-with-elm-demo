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
      [ test "LEDs are off initially" <|
        \_ ->
          let
            model = SimpleBlues.initModel
          in
            Expect.equal Grid.off (SimpleBlues.gridButton 0 model)
      , test "A grid press changes an LED that is off to blue" <|
        \_ ->
          let
            model = SimpleBlues.initModel
          in
            Expect.equal Grid.blue (SimpleBlues.gridButton 0 (SimpleBlues.update 0 model))
      , test "A grid press changes an LED that is blue to off" <|
        \_ ->
          let
            model = SimpleBlues.update 0 SimpleBlues.initModel
          in
            Expect.equal Grid.off (SimpleBlues.gridButton 0 (SimpleBlues.update 0 model))
      ]
    , describe "Sneaky greens"
      [ test "LEDs are off initially" <|
        \_ ->
          let
            model = SneakyGreens.initModel
          in
            Expect.equal Grid.off (SneakyGreens.gridButton 0 model)
      , test "A grid press changes an LED that is off to red" <|
        \_ ->
          let
            model = SneakyGreens.initModel
          in
            Expect.equal Grid.red (SneakyGreens.gridButton 0 (SneakyGreens.update 0 model))
      , test "A grid press changes an LED that is red to green" <|
        \_ ->
          let
            model = SneakyGreens.update 0 (SneakyGreens.initModel)
          in
            Expect.equal Grid.green (SneakyGreens.gridButton 0 (SneakyGreens.update 0 model))
      , test "A grid press changes an LED that is green to off" <|
        \_ ->
          let
            model = SneakyGreens.update 0 (SneakyGreens.update 0 (SneakyGreens.initModel))
          in
            Expect.equal Grid.off (SneakyGreens.gridButton 0 (SneakyGreens.update 0 model))
      ]
    ]
