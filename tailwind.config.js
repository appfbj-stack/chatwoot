const { slateDark } = require('@radix-ui/colors');
import { colors } from './theme/colors';
import { icons } from './theme/icons';
const defaultTheme = require('tailwindcss/defaultTheme');
const {
  iconsPlugin,
  getIconCollections,
} = require('@egoist/tailwindcss-icons');

const defaultSansFonts = [
  '-apple-system',
  'system-ui',
  'BlinkMacSystemFont',
  '"Segoe UI"',
  'Roboto',
  '"Helvetica Neue"',
  'Tahoma',
  'Arial',
  'sans-serif !important',
];

const tailwindConfig = {
  darkMode: 'class',
  content: [
    './enterprise/app/views/**/*.erb',
    './app/javascript/superadmin_pages/**/*.vue',
    './app/javascript/widget/**/*.vue',
    './app/javascript/v3/**/*.vue',
    './app/javascript/dashboard/**/*.vue',
    './app/javascript/portal/**/*.vue',
    './app/javascript/shared/**/*.vue',
    './app/javascript/survey/**/*.vue',
    './app/javascript/dashboard/components-next/**/*.vue',
    './app/javascript/dashboard/helper/**/*.js',
    './app/javascript/dashboard/composables/**/*.js',
    './app/javascript/dashboard/components-next/**/*.js',
    './app/javascript/dashboard/routes/dashboard/**/**/*.js',
    './app/views/**/*.erb',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: defaultSansFonts,
        inter: ['Inter', ...defaultSansFonts],
        interDisplay: ['InterDisplay', ...defaultSansFonts],
      },
      fontWeight: {
        420: '420',
        440: '440',
        460: '460',
        520: '520',
        620: '620',
      },
      typography: {
        bubble: {
          css: {
            color: 'rgb(var(--slate-12))',
            lineHeight: '1.6',
            fontSize: '14px',
            '*': {
              '&:first-child': {
                marginTop: '0',
              },
            },
            overflowWrap: 'anywhere',

            strong: {
              color: 'rgb(var(--slate-12))',
              fontWeight: '700',
            },

            b: {
              color: 'rgb(var(--slate-12))',
              fontWeight: '700',
            },

            h1: {
              color: 'rgb(var(--slate-12))',
              fontWeight: '700',
              fontSize: '1.25rem',
              '&:first-child': {
                marginTop: '0',
              },
            },
            h2: {
              color: 'rgb(var(--slate-12))',
              fontWeight: '700',
              fontSize: '1rem',
              '&:first-child': {
                marginTop: '0',
              },
            },
            h3: {
              color: 'rgb(var(--slate-12))',
              fontWeight: '700',
              fontSize: '1rem',
              '&:first-child': {
                marginTop: '0',
              },
            },
            hr: {
              marginTop: '1.5em',
              marginBottom: '1.5em',
            },
            a: {
              color: 'rgb(var(--slate-12))',
              textDecoration: 'underline',
            },
            ul: {
              paddingInlineStart: '0',
              listStylePosition: 'inside',
            },
            ol: {
              paddingInlineStart: '0',
              listStylePosition: 'inside',
            },
            'ul > li': {
              marginBlockEnd: '0.5em',
              listStyleType: 'disc',
              paddingInlineStart: '1.5em',
              textIndent: '-1.5em',
            },
            'ol > li': {
              marginBlockEnd: '0.5em',
              listStyleType: 'decimal',
              paddingInlineStart: '1.5em',
              textIndent: '-1.5em',
            },
            'li > p:first-child': {
              display: 'inline',
            },
            'li > *': {
              textIndent: '0',
            },
            blockquote: {
              color: 'rgb(var(--slate-11))',
              borderLeft: `4px solid rgb(var(--black-alpha-1))`,
              paddingLeft: '1em',
              '[dir="rtl"] &': {
                borderLeft: 'none',
                paddingLeft: '0',
                borderRight: `4px solid rgb(var(--black-alpha-1))`,
                paddingRight: '1em',
              },
              '[dir="ltr"] &': {
                borderRight: 'none',
                paddingRight: '0',
              },
            },
            code: {
              backgroundColor: 'rgb(var(--alpha-3))',
              color: 'rgb(var(--slate-11))',
              padding: '0.2em 0.4em',
              borderRadius: '4px',
              fontSize: '0.95em',
              '&::before': {
                content: `none`,
              },
              '&::after': {
                content: `none`,
              },
            },
            pre: {
              backgroundColor: 'rgb(var(--alpha-3))',
              padding: '1em',
              borderRadius: '6px',
              overflowX: 'auto',
            },
            table: {
              width: '100%',
              borderCollapse: 'collapse',
            },
            th: {
              padding: '0.75em',
              color: 'rgb(var(--slate-12))',
              border: `none`,
              textAlign: 'start',
              fontWeight: '600',
            },
            tr: {
              border: `none`,
            },
            td: {
              padding: '0.75em',
              border: `none`,
            },
            img: {
              maxWidth: '100%',
              height: 'auto',
              marginTop: 'unset',
              marginBottom: 'unset',
            },
          },
        },
      },
    },
    screens: {
      xs: '480px',
      sm: '640px',
      md: '768px',
      lg: '1024px',
      xl: '1280px',
      '2xl': '1536px',
      '3xl': '1900px',
    },
    fontSize: {
      ...defaultTheme.fontSize,
      xxxs: '0.5rem',
      xxs: '0.625rem',
    },
    colors: {
      transparent: 'transparent',
      white: '#fff',
      'modal-backdrop-light': 'rgba(0, 0, 0, 0.4)',
      'modal-backdrop-dark': 'rgba(0, 0, 0, 0.6)',
      current: 'currentColor',
      ...colors,
      body: slateDark.slate7,
    },
    keyframes: {
      ...defaultTheme.keyframes,
      wiggle: {
        '0%': { transform: 'translateX(0)' },
        '15%': { transform: 'translateX(0.375rem)' },
        '30%': { transform: 'translateX(-0.375rem)' },
        '45%': { transform: 'translateX(0.375rem)' },
        '60%': { transform: 'translateX(-0.375rem)' },
        '75%': { transform: 'translateX(0.375rem)' },
        '90%': { transform: 'translateX(-0.375rem)' },
        '100%': { transform: 'translateX(0)' },
      },
      'fade-in-up': {
        '0%': { opacity: 0, transform: 'translateY(0.5rem)' },
        '100%': { opacity: 1, transform: 'translateY(0)' },
      },
      'loader-pulse': {
        '0%': { opacity: 0.4 },
        '50%': { opacity: 1 },
        '100%': { opacity: 0.4 },
      },
      'card-select': {
        '0%, 100%': {
          transform: 'translateX(0)',
        },
        '50%': {
          transform: 'translateX(1px)',
        },
      },
      shake: {
        '0%, 100%': { transform: 'translateX(0)' },
        '25%': { transform: 'translateX(0.234375rem)' },
        '50%': { transform: 'translateX(-0.234375rem)' },
        '75%': { transform: 'translateX(0.234375rem)' },
      },
    },
    animation: {
      ...defaultTheme.animation,
      wiggle: 'wiggle 0.5s ease-in-out',
      'fade-in-up': 'fade-in-up 0.3s ease-out',
      'loader-pulse': 'loader-pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      'card-select': 'card-select 0.25s ease-in-out',
      shake: 'shake 0.3s ease-in-out 0s 2',
    },
  },
  plugins: [
    // eslint-disable-next-line
    require('@tailwindcss/typography'),
    iconsPlugin({
      collections: {
        woot: { icons },
        ...getIconCollections([
          'lucide',
          'logos',
          'ri',
          'ph',
          'material-symbols',
          'teenyicons',
          'fluent',
        ]),
      },
    }),
    // Kairos: design system tokens `n-*` (todos os ~100 usados no Chatwoot)
    // addUtilities EXPLÍCITO com cada prefixo (border-, bg-, text-, outline-, border-t-, etc)
    // Cobre todas as variantes que @apply dos componentes Vue precisa.
    function ({ addUtilities }) {
      const radix = require('@radix-ui/colors');
      const slate = radix.slate;
      const slateDarkC = radix.slateDark;
      const jade = radix.jade;
      const jadeDark = radix.jadeDark;

      const tokens = {
        weak: slate.slate4,
        strong: slate.slate8,
        emphasis: slate.slate12,
        brand: jadeDark.jade10,
        background: slate.slate1,
        card: slate.slate2,
        container: slate.slate1,
        portal: jade.jade2,
        'portal-soft': jade.jade3,
        black: slateDarkC.slate1,
        'button-color': slate.slate1,
        'call-widget': slate.slate2,
        'call-widget-border': slate.slate4,
        'call-widget-text': slate.slate11,
        'call-widget-sub-text': slate.slate9,
        'dropdown-body': slate.slate2,
        'dropdown-item': slate.slate3,
        'dropdown-section': slate.slate4,
        'input-background': slate.slate2,
        'label-border': slate.slate6,
        'label-color': slate.slate9,
      };
      for (let i = 1; i <= 12; i++) {
        tokens['slate-' + i] = slate['slate' + i];
        tokens['blue-' + i] = radix.blue['blue' + i];
        tokens['amber-' + i] = radix.amber['amber' + i];
        tokens['ruby-' + i] = radix.ruby['ruby' + i];
        tokens['iris-' + i] = radix.iris['iris' + i];
        tokens['teal-' + i] = radix.teal['teal' + i];
        tokens['gray-' + i] = radix.gray['gray' + i];
        tokens['violet-' + i] = radix.violet['violet' + i];
        tokens['red-' + i] = radix.red['red' + i];
      }
      tokens['alpha-1'] = slate.slateA3;
      tokens['alpha-2'] = slate.slateA5;
      tokens['alpha-3'] = slate.slateA7;
      tokens['alpha-white'] = '#ffffff20';
      tokens['solid-1'] = slate.slate4;
      tokens['solid-2'] = slate.slate5;
      tokens['solid-3'] = slate.slate6;
      tokens['solid-active'] = slate.slate12;
      tokens['solid-amber'] = radix.amber.amber9;
      tokens['solid-blue'] = radix.blue.blue9;
      tokens['solid-iris'] = radix.iris.iris9;
      tokens['surface-1'] = slate.slate1;
      tokens['surface-2'] = slate.slate2;
      tokens['woot-600'] = jadeDark.jade8;
      tokens['woot-700'] = jadeDark.jade7;
      tokens['amber-text'] = radix.amber.amber11;
      tokens['blue-text'] = radix.blue.blue11;
      tokens['blue-border'] = radix.blue.blue6;

      const prefixes = [
        { name: '', type: 'color' },
        { name: 'border-', type: 'border-color' },
        { name: 'bg-', type: 'background-color' },
        { name: 'text-', type: 'color' },
        { name: 'outline-', type: 'outline-color' },
        { name: 'border-t-', type: 'border-top-color' },
        { name: 'border-r-', type: 'border-right-color' },
        { name: 'border-b-', type: 'border-bottom-color' },
        { name: 'border-l-', type: 'border-left-color' },
        { name: 'ring-', type: '--tw-ring-color' },
        { name: 'divide-', type: 'border-color' },
        { name: 'placeholder-', type: 'color' },
        { name: 'caret-', type: 'caret-color' },
        { name: 'accent-', type: 'accent-color' },
        { name: 'fill-', type: 'fill' },
        { name: 'stroke-', type: 'stroke' },
        { name: 'decoration-', type: 'text-decoration-color' },
        { name: 'from-', type: '--tw-gradient-from' },
        { name: 'via-', type: '--tw-gradient-via' },
        { name: 'to-', type: '--tw-gradient-to' },
      ];

      const utilities = {};
      for (const [key, value] of Object.entries(tokens)) {
        for (const { name: prefix, type: prop } of prefixes) {
          const cls = '.' + prefix + 'n-' + key;
          if (prop === '--tw-ring-color') {
            utilities[cls] = { '--tw-ring-color': value };
          } else if (prop === '--tw-gradient-from') {
            utilities[cls] = { '--tw-gradient-from': value + ' var(--tw-gradient-from-position)' };
          } else if (prop === '--tw-gradient-via') {
            utilities[cls] = { '--tw-gradient-via': value + ' var(--tw-gradient-via-position)' };
          } else if (prop === '--tw-gradient-to') {
            utilities[cls] = { '--tw-gradient-to': value + ' var(--tw-gradient-to-position)' };
          } else {
            utilities[cls] = { [prop]: value };
          }
        }
      }
      addUtilities(utilities, ['responsive', 'dark']);
    },
  ],
};

module.exports = tailwindConfig;
