function debounce(func, timeout = 300){
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

const WindowResize = {
  mounted() {
    // Direct push of current window size to properly update view
    this.pushResizeEvent()

    resizeHandler = debounce(() => {
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
