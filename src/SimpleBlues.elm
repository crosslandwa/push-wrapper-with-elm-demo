module SimpleBlues exposing (Model, initModel, gridButton, update)

import Array exposing (Array)
import GridButton

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

gridButton : Int -> Model -> GridButton.GridButton msg
gridButton index model =
  case model of
    Model values ->
      case Maybe.withDefault Off (Array.get index values) of
        Off ->
          GridButton.off
        On ->
          GridButton.blue

update : Int -> Model -> Model
update index (Model values) =
  Model (Array.indexedMap (\i x -> if i == index then toggle x else x) values)
