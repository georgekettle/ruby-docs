const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './config/initializers/*.rb'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#ff4124',
          '50': '#fff2f0',
          '100': '#ffddd7',
          '200': '#fdb9af',
          '300': '#fb9c8d',
          '400': '#ff6952',
          '500': '#ff4124',
          '600': '#f03114',
          '700': '#da2b10',
          '800': '#bc2710',
          '900': '#a72511',
        },
        contrast: {
          DEFAULT: '#4dbc1a',
          '50': '#f0fce8',
          '100': '#def7ce',
          '200': '#c2f2a6',
          '300': '#99e76f',
          '400': '#72da3e',
          '500': '#4dbc1a',
          '600': '#3d9a19',
          '700': '#2f7416',
          '800': '#2a5e17',
          '900': '#245115',
        },
        yellow: {
          DEFAULT: '#fd7521',
          '50': '#fff8eb',
          '100': '#ffefd1',
          '200': '#ffdb9e',
          '300': '#ffc05c',
          '400': '#ffaf47',
          '500': '#ff9233',
          '600': '#fd7521',
          '700': '#fa660a',
          '800': '#e94707',
          '900': '#d74309',
        }
      },
      maxWidth: {
        '8xl': '90rem',
      },
      spacing: {
        '1px': '1px',
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
