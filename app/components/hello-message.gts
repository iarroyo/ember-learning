import type { TOC } from '@ember/component/template-only';

interface HelloMessageSignature {
  Args: {
    name?: string;
  };
  Element: HTMLParagraphElement;
}

const getDisplayName = (name?: string): string => {
  return name || 'World';
};

const HelloMessage = <TOC<HelloMessageSignature>>(
  <template>
    <p class="greeting">Hello, {{getDisplayName @name}}!</p>
  </template>
);

export { HelloMessage };
