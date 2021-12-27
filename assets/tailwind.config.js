const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  mode: "jit",
  content: [
    './js/**/*.js',
    "../lib/*_web/components/**/*.{ex,heex}",
    "../lib/*_web/live/**/*.{ex,heex}",
    "../lib/*_web/templates/**/*.{ex,heex}",
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    }
  },
  variants: {
    extend: {
      borderStyle: ['last'],
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio')
  ],
};
