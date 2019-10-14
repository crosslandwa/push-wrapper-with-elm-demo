module Main exposing (..)

import Browser
import Grid exposing (GridButton)
import Ports
import SimpleBlues
import SneakyGreens
import Html exposing (Html, text, div, h1)
import Html.Attributes exposing (class)
import Html.Events

---- MODEL ----


type alias Model =
  { blues: SimpleBlues.Model
  , greens: SneakyGreens.Model
  , appLayer: AppLayer
  }

type AppLayer
  = ShowSimpleBlues
  | ShowSneakyGreens

init : ( Model, Cmd Msg )
init =
  (
  { blues = SimpleBlues.initModel
  , greens = SneakyGreens.initModel
  , appLayer = ShowSimpleBlues
  }, Cmd.none )



---- UPDATE ----

type Msg
  = GridButtonPressed Int Int

toggleAppLayer : Model -> (Model, Cmd Msg)
toggleAppLayer model =
  (
    { model | appLayer =
        if model.appLayer == ShowSimpleBlues then ShowSneakyGreens else ShowSimpleBlues }
    , Cmd.none
  )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GridButtonPressed x y ->
      let
        index = y * 8 + x
      in
        case index of
          0 ->
            toggleAppLayer model
          7 ->
            toggleAppLayer model
          56 ->
            toggleAppLayer model
          63 ->
            toggleAppLayer model
          _ ->
            case model.appLayer of
              ShowSimpleBlues ->
                (
                  { model | blues = SimpleBlues.update index model.blues }
                  , Cmd.none
                )
              ShowSneakyGreens ->
                (
                  { model | greens = SneakyGreens.update index model.greens }
                  , Cmd.none
                )


---- VIEW ----

appLayerGridButton : Model -> GridButton msg
appLayerGridButton m =
  case m.appLayer of
    ShowSimpleBlues ->
      Grid.blue
    ShowSneakyGreens ->
      Grid.green

gridButton : Int -> Model -> GridButton msg
gridButton index model =
  case index of
    0 ->
      appLayerGridButton model
    7 ->
      appLayerGridButton model
    56 ->
      appLayerGridButton model
    63 ->
      appLayerGridButton model
    _ ->
      case model.appLayer of
        ShowSimpleBlues ->
          SimpleBlues.gridButton index model.blues
        ShowSneakyGreens ->
          SneakyGreens.gridButton index model.greens

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "WAC machine" ]
    , div [ class "wac-grid"]
      (List.map (\i ->
        let
          x = modBy 8 i
          y = i // 8
        in
          (gridButton i model) x y (GridButtonPressed x y)
      ) (List.range 0 63))
    ]


---- SUBSCRIPIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.hardwareGridButtonPressed (\{x, y, velocity} -> GridButtonPressed x y)

---- PROGRAM ----

main : Program () Model Msg
main =
  Browser.element
    { view = view
    , init = \_ -> init
    , update = update
    , subscriptions = subscriptions
    }
