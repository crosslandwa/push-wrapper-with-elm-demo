import './main.css';
import { Elm } from './Main.elm';
import pushWrapper from 'push-wrapper'

(function initialiseApp () {
  const app = Elm.Main.init({
    node: document.getElementById('root')
  })

  function bindElmDOMToPush (push) {
    bindGridPadLeds(push)
    bindGridPadPresses(app, push)
  }

  loadPush()
    .then(bindElmDOMToPush)
})()

function loadPush () {
  return pushWrapper.webMIDIio()
    .catch(err => { console.warn(err); return { inputPort: {}, outputPort: { send: () => {} } } })
    .then(({inputPort, outputPort}) => {
      const push = pushWrapper.push()
      inputPort.onmidimessage = event => push.midiFromHardware(event.data)
      push.onMidiToHardware(outputPort.send.bind(outputPort))
      return push
    })
}

function bindGridPadLeds (push) {
  const updatePad = node => {
    const x = parseInt(node.dataset.x)
    const y = parseInt(node.dataset.y)
    const rgb = JSON.parse(node.dataset.rgb).slice(0, 3)
    push.gridCol(x)[y].ledRGB(...rgb)
  }

  [...document.getElementsByClassName('wac-grid__button')].forEach(updatePad)

  new MutationObserver(function(mutations, observer) {
    mutations
      .filter(x => x.type === 'attributes' && x.attributeName === 'data-rgb')
      .forEach(mutation => updatePad(mutation.target))
  }).observe(
    document.getElementsByClassName('wac-grid')[0],
    { attributes: true, childList: false, subtree: true }
  )
}

function bindGridPadPresses (app, push) {
  [0, 1, 2, 3, 4, 5, 6, 7].forEach(x => push.gridCol(x).forEach((pad, y) => {
    pad.onPressed(velocity => app.ports.hardwareGridButtonPressed.send({x, y, velocity}))
  }))
}
