import _ from 'lodash'

const WindowResize = {
  mounted() {
    // Direct push of current window size to properly update view
    this.pushResizeEvent()

    resizeHandler = _.debounce(() => {
      this.pushResizeEvent()
    }, 100)
    window.addEventListener('resize', resizeHandler)
  },

  pushResizeEvent() {
    this.pushEventTo('#scoreboard','viewport_resize', {
      width: window.innerWidth,
      height: window.innerHeight
    })
  }
}

export {WindowResize}
