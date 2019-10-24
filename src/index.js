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
    bindGridSelectButtonLeds(push)
    bindGridSelectButtonPresses(app, push)
  }

  loadPush()
    .then(bindElmDOMToPush)

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

  function bindRgbLed (cssBlock, update) {
    [...document.getElementsByClassName(`${cssBlock}__button`)].forEach(update)

    new MutationObserver(function(mutations, observer) {
      mutations
        .filter(x => x.type === 'attributes' && x.attributeName === 'data-rgb')
        .forEach(mutation => update(mutation.target))
    }).observe(
      document.getElementsByClassName(cssBlock)[0],
      { attributes: true, childList: false, subtree: true }
    )
  }

  function bindGridPadLeds (push) {
    bindRgbLed('wac-grid', node => {
      const x = parseInt(node.dataset.x)
      const y = parseInt(node.dataset.y)
      const rgb = JSON.parse(node.dataset.rgb)
      push.gridCol(x)[y].ledRGB(...rgb)
    })
  }

  function bindGridPadPresses (app, push) {
    [0, 1, 2, 3, 4, 5, 6, 7].forEach(x => push.gridCol(x).forEach((pad, y) => {
      pad.onPressed(velocity => app.ports.hardwareGridButtonPressed.send({x, y, velocity}))
    }))
  }

  function bindGridSelectButtonLeds (push) {
    bindRgbLed('wac-grid-select', node => {
      const x = parseInt(node.dataset.x)
      const rgb = JSON.parse(node.dataset.rgb)
      push.gridSelectButtons()[x].ledRGB(...rgb)
    })
  }

  function bindGridSelectButtonPresses (app, push) {
    push.gridSelectButtons().forEach((button, x) => {
      button.onPressed(velocity => app.ports.hardwareGridSelectButtonPressed.send({x}))
    })
  }

})()
