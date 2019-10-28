module SimpleBlues exposing (Model, Msg, initModel, isActive, gridButton, gridButtonPressed, update)

import Array exposing (Array)
import GridButton exposing (GridButton)


type OffOn
  = Off
  | On


type Model
 = Model (Array OffOn)


type Msg
 = Toggle Int


initModel : Model
initModel =
  Model (Array.repeat 64 Off)


indexFrom x y =
  x + y * 8


gridButton : Int -> Int -> Model -> GridButton Msg
gridButton x y model =
  let
    index = indexFrom x y
    button = if (isActive index model) then GridButton.blue else GridButton.off
  in
    button x y (Toggle index)


gridButtonPressed : Int -> Int -> Msg
gridButtonPressed x y =
  Toggle (indexFrom x y)


update : Msg -> Model -> Model
update msg (Model values) =
  case msg of
    Toggle index ->
      let
        toggle current =
          case current of
            Off -> On
            On -> Off
      in
        Model (Array.indexedMap (\i x -> if i == index then toggle x else x) values)


isActive : Int -> Model -> Bool
isActive index (Model values) =
  Maybe.withDefault Off (Array.get index values) == On
