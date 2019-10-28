module GridButton exposing (GridButton, toHtml, map, off, green, red, blue)

import Html exposing (Html)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (onClick)

type GridButton msg =
  GridButton Int Int Color msg

toHtml : GridButton msg -> Html msg
toHtml detail =
  button detail

map : (a -> msg) -> GridButton a -> GridButton msg
map mapped (GridButton x y color message) =
  GridButton x y color (mapped message)

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

off : Int -> Int -> msg -> GridButton msg
off x y action =
  GridButton x y Off action

blue : Int -> Int -> msg -> GridButton msg
blue x y action =
  GridButton x y Blue action

green : Int -> Int -> msg -> GridButton msg
green x y action =
  GridButton x y Green action

red : Int -> Int -> msg -> GridButton msg
red x y action =
  GridButton x y Red action

button : GridButton msg -> Html msg
button (GridButton x y color action) =
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
