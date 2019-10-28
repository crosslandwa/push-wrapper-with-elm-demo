module SimpleBluesTests exposing (all)

import Test exposing (..)
import Expect
import SimpleBlues

type DummyMsg = DummyMsg

all : Test
all =
  describe "Simple blues"
    [ test "Elements are inactive initially and are toggled on/off by subsequent updates" <|
      \_ ->
        let
          updateFirstElementTimes : Int -> List SimpleBlues.Model -> List SimpleBlues.Model
          updateFirstElementTimes n models =
            if n <= 0 then
              models
            else
              case models of
                [] ->
                  updateFirstElementTimes (n - 1) [SimpleBlues.initModel]
                model::rest ->
                  updateFirstElementTimes
                    (n - 1)
                    ((SimpleBlues.update (SimpleBlues.gridButtonPressed 0 0) model) :: (model :: rest))
        in
          updateFirstElementTimes 6 []
            |> List.map (SimpleBlues.isActive 0)
            |> List.reverse -- initial model is last in list returned from updateFirstElementTimes
            |> Expect.equal [False, True, False, True, False, True]
    ]
