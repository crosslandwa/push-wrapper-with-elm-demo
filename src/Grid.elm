module Grid exposing (GridButton, off, green, red, blue)

import Html exposing (Html)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (onClick)

type alias GridButton msg = (Int -> Int -> msg -> Html msg)

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
  "[" ++ String.join ", " (List.map String.fromInt values) ++ "]"

off : GridButton msg
off x y action =
  button x y Off action

blue : GridButton msg
blue x y action =
  button x y Blue action

green : GridButton msg
green x y action =
  button x y Green action

red : GridButton msg
red x y action =
  button x y Red action

button : Int -> Int -> Color -> msg -> Html msg
button x y color action =
  Html.button
    [ onClick action
    , class "wac-grid__button"
    , class ("wac-grid__button--x-" ++ String.fromInt x)
    , class ("wac-grid__button--y-" ++ String.fromInt y)
    , style "background-color" (toBackgroundColor (toRGB color))
    , attribute "data-x" (String.fromInt x)
    , attribute "data-y" (String.fromInt y)
    , attribute "data-rgb" (toRGBDataAttribute (toRGB color))
    ] [ ]
