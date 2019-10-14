port module Ports exposing (..)

port hardwareGridButtonPressed : ({ x: Int, y: Int, velocity: Int} -> msg) -> Sub msg
