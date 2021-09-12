const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  mode: "jit",
  purge: [
    "./js/**/*.js",
    "../lib/*_web/**/*.*ex",
    "../lib/*_web/**/*.*heex",
    "./stories/**/*.html"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio')
  ],
};
