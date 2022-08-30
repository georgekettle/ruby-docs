const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT:'#ff7262',
          '50': '#fff2f1',
          '100': '#ffe4e1',
          '200': '#ffcdc7',
          '300': '#ffaaa0',
          '400': '#ff7262',
          '500': '#f84e3b',
          '600': '#e5311d',
          '700': '#c12614',
          '800': '#a02214',
          '900': '#842318',
        }
      }
    },
    fontFamily: {
      sans: [...defaultTheme.fontFamily.sans],
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
