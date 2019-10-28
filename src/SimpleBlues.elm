module SimpleBlues exposing (Model, initModel, gridButton, update)

import Array exposing (Array)
import GridButton exposing (GridButton)

type OffOn
  = Off
  | On

type Model
 = Model (Array OffOn)

initModel : Model
initModel =
  Model (Array.repeat 64 Off)

toggle : OffOn -> OffOn
toggle current =
  case current of
    Off ->
      On
    On ->
      Off

gridButton : Int -> Int -> Model -> (msg -> GridButton msg)
gridButton x y model =
  case model of
    Model values ->
      case Maybe.withDefault Off (Array.get (x + y * 8) values) of
        Off ->
          GridButton.off x y
        On ->
          GridButton.blue x y

update : Int -> Model -> Model
update index (Model values) =
  Model (Array.indexedMap (\i x -> if i == index then toggle x else x) values)
