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
  safelist: [{
    pattern: /rating-(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20)/,
    variants: ['text']
    },
    {
      pattern: /(angry|very-unhappy|unhappy|normal|good|very-good|great)/,
      variants: ['text']
    },
    'w-1/20',
    'w-2/20',
    'w-3/20',
    'w-4/20',
    'w-5/20',
    'w-6/20',
    'w-7/20',
    'w-8/20',
    'w-9/20',
    'w-10/20',
    'w-11/20',
    'w-12/20',
    'w-13/20',
    'w-14/20',
    'w-15/20',
    'w-16/20',
    'w-17/20',
    'w-18/20',
    'w-19/20',
    'w-20/20'
  ],
  theme: {
    extend: {
      colors: {
        'angry': "#c0040c",
        'very-unhappy': "#f83404",
        'unhappy': "#f87c0c",
        'normal': "#ffdc04" ,
        'good': "#58cc04",
        'very-good': "#08a4c4",
        'great': "#20bcec",
        rating: {
          1: "#c0040c",
          2: "#e0040c",
          3: "#e0040c",
          4: "#f83404",
          5: "#f83404",
          6: "#f87c0c",
          7: "#f87c0c",
          8: "#ffc404",
          9: "#ffc404",
          10: "#ffdc04",
          11: "#ffdc04",
          12: "#b8dc04",
          13: "#b8dc04",
          14: "#58cc04",
          15: "#58cc04",
          16: "#08c4a4",
          17: "#08c4a4",
          18: "#08a4c4",
          19: "#08a4c4",
          20: "#20bcec"
        }
      },
      width: {
        '1/20': '5%',
        '2/20': '10%',
        '3/20': '15%',
        '4/20': '20%',
        '5/20': '25%',
        '6/20': '30%',
        '7/20': '35%',
        '8/20': '40%',
        '9/20': '45%',
        '10/20': '50%',
        '11/20': '55%',
        '12/20': '60%',
        '13/20': '65%',
        '14/20': '70%',
        '15/20': '75%',
        '16/20': '80%',
        '17/20': '85%',
        '18/20': '90%',
        '19/20': '95%',
        '20/20': '100%',
      },
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
