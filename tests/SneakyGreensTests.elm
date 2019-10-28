module SneakyGreensTests exposing (all)

import Test exposing (..)
import Expect
import SneakyGreens exposing (TriState(..))

all : Test
all =
  describe "Sneaky greens"
    [ test "Elements are initially in state A and move through B/C/A on subsequent updates" <|
      \_ ->
        let
          updateFirstElementTimes : Int -> List SneakyGreens.Model -> List SneakyGreens.Model
          updateFirstElementTimes n models =
            if n <= 0 then
              models
            else
              case models of
                [] ->
                  updateFirstElementTimes (n - 1) [SneakyGreens.initModel]
                model::rest ->
                  updateFirstElementTimes
                    (n - 1)
                    ((SneakyGreens.update (SneakyGreens.gridButtonPressed 0 0) model) :: (model :: rest))
        in
          updateFirstElementTimes 6 []
            |> List.map (SneakyGreens.elementState 0)
            |> List.reverse -- initial model is last in list returned from updateFirstElementTimes
            |> Expect.equal [A, B, C, A, B, C] -- TODO exposing the union type members here is a leaky abstraction
    ]
