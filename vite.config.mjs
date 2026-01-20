import { defineConfig } from 'vite';
import { extensions, classicEmberSupport, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';
import tailwindcss from '@tailwindcss/vite';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  plugins: [
    classicEmberSupport(),
    ember(),
    tailwindcss(),
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],
  resolve: {
    alias: {
      'ember-learning/tests': path.resolve(__dirname, 'tests'),
      'ember-learning': path.resolve(__dirname, 'app'),
    },
  },
});
