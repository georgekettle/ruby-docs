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
        },
        contrast: {
          DEFAULT:'#ae5fed',
          '50': '#faf6fe',
          '100': '#f4e9fe',
          '200': '#ebd8fc',
          '300': '#dbb8fa',
          '400': '#c082f4',
          '500': '#ae5fed',
          '600': '#993edf',
          '700': '#842cc4',
          '800': '#6f29a0',
          '900': '#5b2281',
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
