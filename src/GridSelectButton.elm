module GridSelectButton exposing (GridSelectButton, off, green, red, blue)

import Html exposing (Html)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (onClick)

type alias GridSelectButton msg = (Int -> msg -> Html msg)

type Color
  = Off
  | Red
  | Green
  | Blue

toRGB : Color -> List Int
toRGB color =
  case color of
    Off -> [0, 0, 0, 0] -- note the 4th 0 here to produce an alpha for HTML rendering
    Red -> [255, 0, 0]
    Green -> [0, 255, 0]
    Blue -> [0, 0, 255]

toBackgroundColor : List Int -> String
toBackgroundColor values =
  "rgb(" ++ String.join ", " (List.map String.fromInt values) ++ ")"

toRGBDataAttribute : List Int -> String
toRGBDataAttribute values =
  "[" ++ String.join ", " (List.map String.fromInt (List.take 3 values)) ++ "]"

off : GridSelectButton msg
off x action =
  button x Off action

blue : GridSelectButton msg
blue x action =
  button x Blue action

green : GridSelectButton msg
green x action =
  button x Green action

red : GridSelectButton msg
red x action =
  button x Red action

button : Int -> Color -> msg -> Html msg
button x color action =
  Html.button
    [ onClick action
    , class "wac-grid-select__button"
    , class ("wac-grid-select__button--x-" ++ String.fromInt x)
    , style "background-color" (toBackgroundColor (toRGB color))
    , attribute "data-x" (String.fromInt x)
    , attribute "data-rgb" (toRGBDataAttribute (toRGB color))
    ] [ ]
