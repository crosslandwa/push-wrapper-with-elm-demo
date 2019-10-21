
# Push / Elm demo application

## What

An toy project to give me an opportunity to try out building an [Elm](https://elm-lang.org/) application and interface it with an Ableton Push (via [push-wrapper](https://github.com/crosslandwa/push-wrapper))

Functionally the app presents two "layers" of toggle-able lights on the grid of the Push
 - press the corner pads to toggle between the blue layer and the red/green layer
 - press grid pads to toggle on/off the blue LEDs
 - press grid pads to cycle through the red/green LEDs

## How

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app)
- full guide of commands this gives is [here](https://github.com/halfzebra/create-elm-app/blob/master/template/README.md)

## Run it

### Pre-requisites
1. Install npm and elm
1. Install create-elm-app (`npm install create-elm-app -g`)
1. Connect your Ableton Push

### And off we go
Check out this code, cd into the directory and then:
1. Install push-wrapper (`npm install`)
1. Run the app (`elm-app start`)

This will build the app, serve it on `localhost:3000` open the default browser (this is known to work with Chrome)

## Tests

The logic of the blue/green/game of life "layers" (see *multiple application layers* below) is tested via `tests/Tests.elm` - these can be run by:
```
elm-app test
```

These tests **could be much better written** - in their verbose state they are proving the point that i *can*:
- extract/test portions of the applications behaviour in isolation (i.e. by testing individual modules)
- test against the "public API" that module presents (without knowing about internal implementation details)

*Note I've not looked into testing the rendered HTML*

## Design notes

### Multiple application layers

I was interested in how to model multiple "layers" being controlled/displayed on the Push grid "at the same time" within the Elm app. The three "layers" here (simple blues, sneaky greens and game of life) are logically simple, but forced me to think about how this might be handled in a way that was scalable for a complex application (e.g. a step-sequencer with multiple patterns, voices, etc)
- I started with "everything handled in one model/update/view in `src/Main.elm`"
  - Mixing all the concerns into one file made things difficult to reason about, as you'd expect, but was a starting point from which I could refactor
- The "main" module ended up:
  - Keeping a track of which layer is currently selected (i.e. stored in the model), and enabling it to be changed (i.e. via an update)
  - Forwarding pad presses into an "update" function for the currently selected layer
  - Rendering each of the 64 pads, but delegating to the currently selected layer to determine the colour
  - Aggregating the "state" of each layer into the master model, but avoiding interacting with it (for updates/view rendering) via Elms [opaque types](https://8thlight.com/blog/mike-knepper/2019/02/26/types-of-types-in-elm.html)
- The "layers" (simple blues/sneaky greens) now become well encapsulated and straightforward to test (they functional and stateless)
	- As a proof of concept I'm happy this would be scalable, however, I can see the approach falling down if the grid ever has to show "multiple things at the same time" (e.g. the top half shows layer A, whilst the bottom half shows layer B)...
- Following this approach the third GameOfLife layer was written via TDD
  - initially it was difficult to test as the exposed "gridish" API (`update`/`gridbutton`) made the intent of the tests unclear
  - by refactoring to separate a GameOfLife module with a descriptive API (exposing `toggleCell`, `evolve`, `isAlive`) the tests became easy to write (and thus the actual logic easy to deliver via TDD)
  - an (untested) GameOfLifeAdaptor module was created to adapt between the "gridish" API and the GameOfLife API. This means the GameOfLife API is exposed for testing, but not used directly from the `Main` module. This feels like another refinement that would improve _scalability_ if the app had several (complex) layers


### DOM rendering

The application uses Elms HTML rendering (see `src/Main.elm`) to display 64 buttons - these represent the pads of the Push grid

### Styles

The buttons are styled to look like the Push hardware - styling is via hand-cranked CSS (`src/main.css`), which is imported and bundled into the build via `src/index.js`

### Controlling Push LEDs

Push LEDs are turned on/off by sending MIDI messages to the Push hardware via push-wrapper (and the Web MIDI API). The following approaches were considered

- Use Elms ports to send MIDI messages as a side-effect of issued [commands](https://guide.elm-lang.org/effects/json.html), using Elm ports to call into the push-wrapper (JS) library
  - Despite the sending of MIDI messages being a side-effect, this felt like the wrong pattern and was discarded.
  - I'd end up duplicating logic between the code to turn on/off LEDs on the hardware (i.e. issuing of appropriate commands during the _update_ cycle) and the code for creating the DOM representation of the hardware (i.e. the _view rendering_ cycle)
- Write a Elm 'view library' to send the appropriate push messages as part of Elms view rendering
  - Discarded as this would require a lower-level understanding of Elm than I wanted to go into for this project
- Use JS mutation observers to watch for changes of the Elm rendered (DOM) view, and keep the hardware LEDs in-sync with that
	- The DOM representation (HTML buttons) add data-attributes to describe the buttons grid position (x/y coordinates) and the RGB colour (see `src/Grid.elm)
	- A mutation observer is added that interacts with the push-wrapper library in the (`src/index.js`) `bindGridPadLeds` function
	- This approach ensures Elm "owns" what the grid should look like (through it's view rendering) at the cost of some hidden coupling between the HTML button rendering at the `bindGridPadLeds` function


### Receiving button presses from Push

This uses standard Elm [ports/subscriptions](https://guide.elm-lang.org/effects/time.html)
- The elm application exposes a `hardwareGridButtonPressed` port (see `src/Ports.elm`)
- Hardware button presses are exposed via `push-wrapper` and bound to Elm ports in the (`src/index.js`) `bindGridPadPresses` function
- The elm application subscribes to the `hardwareGridButtonPressed` port (see `src/Main.elm`) to generate `GridButtonPressed` messages
