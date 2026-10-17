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
    // Kairos: design system tokens `n-*` (todos os 113 usados no Chatwoot)
    // Cobertura COMPLETA via gerador automatico de tokens.
    function ({ addUtilities }) {
      const radix = require('@radix-ui/colors');
      const slate = radix.slate;
      const slateDarkC = radix.slateDark;
      const jade = radix.jade;
      const jadeDark = radix.jadeDark;

      // Resolvedor de token -> valor CSS
      // Cobrindo todos os 113 tokens n-X encontrados no scan
      const resolveToken = (key) => {
        // Mapeamento fixo de tokens semanticos
        // NOTA: Radix v3 nao tem 'slateA*' ou 'blackA*', entao usamos rgba() fixo
        const fixed = {
          'weak': slate.slate4,
          'strong': slate.slate8,
          'emphasis': slate.slate12,
          'brand': jadeDark.jade10,
          'background': slate.slate1,
          'card': slate.slate2,
          'container': slate.slate1,
          'portal': jade.jade2,
          'portal-soft': jade.jade3,
          'black': slateDarkC.slate1,
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
          // alpha (slate alpha como rgba) — Radix v3 nao exporta
          'alpha-1': 'rgba(0, 0, 0, 0.05)',
          'alpha-2': 'rgba(0, 0, 0, 0.1)',
          'alpha-3': 'rgba(0, 0, 0, 0.2)',
          'alpha-white': 'rgba(255, 255, 255, 0.2)',
          'alpha-black1': 'rgba(0, 0, 0, 0.1)',
          'alpha-black2': 'rgba(0, 0, 0, 0.2)',
          'alpha-black3': 'rgba(0, 0, 0, 0.3)',
          'alpha-black4': 'rgba(0, 0, 0, 0.5)',
          'solid-1': slate.slate4,
          'solid-2': slate.slate5,
          'solid-3': slate.slate6,
          'solid-active': slate.slate12,
          'solid-amber': radix.amber.amber9,
          'solid-blue': radix.blue.blue9,
          'solid-iris': radix.iris.iris9,
          'surface-1': slate.slate1,
          'surface-2': slate.slate2,
          'woot-600': jadeDark.jade8,
          'woot-700': jadeDark.jade7,
          'amber-text': radix.amber.amber11,
          'blue-text': radix.blue.blue11,
          'blue-border': radix.blue.blue6,
        };
        if (fixed[key] !== undefined) return fixed[key];

        // Cores Radix com escala 1..12: slate-N, blue-N, amber-N, ruby-N, iris-N,
        // teal-N, gray-N, violet-N, red-N
        const scaleMatch = key.match(/^(slate|blue|amber|ruby|iris|teal|gray|violet|red)-(\d+)$/);
        if (scaleMatch) {
          const colorName = scaleMatch[1];
          const num = scaleMatch[2];
          if (radix[colorName] && radix[colorName][colorName + num]) {
            return radix[colorName][colorName + num];
          }
        }
        // Fallback: retorna null (Tailwind ignora)
        return null;
      };

      // Lista COMPLETA de todos os 113 tokens encontrados no scan
      const allTokens = [
        'alpha-1', 'alpha-2', 'alpha-3',
        'alpha-black1', 'alpha-black2', 'alpha-black3', 'alpha-black4',
        'alpha-white',
        'amber-2', 'amber-3', 'amber-4', 'amber-5', 'amber-6', 'amber-7', 'amber-8',
        'amber-9', 'amber-10', 'amber-11', 'amber-12', 'amber-text',
        'background', 'black',
        'blue-1', 'blue-2', 'blue-3', 'blue-4', 'blue-5', 'blue-6', 'blue-7', 'blue-8',
        'blue-9', 'blue-10', 'blue-11', 'blue-12', 'blue-border', 'blue-text',
        'brand', 'button-color',
        'call-widget', 'call-widget-border', 'call-widget-text', 'call-widget-sub-text',
        'card', 'container',
        'dropdown-body', 'dropdown-item', 'dropdown-section',
        'emphasis',
        'gray-1', 'gray-5', 'gray-10', 'gray-11', 'gray-12',
        'input-background',
        'iris-2', 'iris-3', 'iris-4', 'iris-5', 'iris-9', 'iris-10', 'iris-11', 'iris-12',
        'label-border', 'label-color',
        'portal', 'portal-soft',
        'red-9',
        'ruby-2', 'ruby-3', 'ruby-4', 'ruby-5', 'ruby-6', 'ruby-7', 'ruby-8', 'ruby-9',
        'ruby-10', 'ruby-11', 'ruby-12',
        'slate-1', 'slate-2', 'slate-3', 'slate-4', 'slate-5', 'slate-6', 'slate-7',
        'slate-8', 'slate-9', 'slate-10', 'slate-11', 'slate-12', 'slate-50',
        'solid-1', 'solid-2', 'solid-3', 'solid-active', 'solid-amber', 'solid-blue',
        'solid-iris',
        'strong',
        'surface-1', 'surface-2',
        'teal-2', 'teal-3', 'teal-4', 'teal-5', 'teal-6', 'teal-7', 'teal-9',
        'teal-10', 'teal-11', 'teal-12',
        'violet-3', 'violet-9',
        'weak',
        'woot-600', 'woot-700',
      ];

      const tokens = {};
      for (const key of allTokens) {
        const val = resolveToken(key);
        if (val) tokens[key] = val;
      }

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
