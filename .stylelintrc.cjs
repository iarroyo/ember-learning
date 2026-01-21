'use strict';

module.exports = {
  extends: ['stylelint-config-standard'],
  rules: {
    // Allow Tailwind CSS v4 at-rules
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: [
          'theme',
          'custom-variant',
          'tailwind',
          'apply',
          'layer',
          'config',
        ],
      },
    ],
    // Allow Tailwind CSS import syntax
    'import-notation': null,
    // Allow oklch color notation with decimal lightness
    'lightness-notation': null,
    // Allow hue values without deg unit
    'hue-degree-notation': null,
  },
};
