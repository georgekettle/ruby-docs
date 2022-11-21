const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './public/*.html',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './config/initializers/*.rb',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        'primary': {
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
        'contrast': {
          '50': '#f5f0ff',
          '100': '#f0e5ff',
          '200': '#e0ccff',
          '300': '#cea8ff',
          '400': '#b675ff',
          '500': '#a53dff',
          '600': '#9d14ff',
          '700': '#9403fc',
          '800': '#7c03d3',
          '900': '#6705ad',
        },      
        'yellow': {
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
      },
      fontFamily: {
        'mono': ['Fira Code', 'ui-monospace'],
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
    require('@tailwindcss/line-clamp'),
  ]
}
