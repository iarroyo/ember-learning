import '@glint/environment-ember-template-imports';
import '@glint/environment-ember-loose/registry';
import type { HelperLike } from '@glint/template';

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    eq: HelperLike<{
      Args: { Positional: [unknown, unknown] };
      Return: boolean;
    }>;
    not: HelperLike<{
      Args: { Positional: [unknown] };
      Return: boolean;
    }>;
    noop: HelperLike<{
      Args: { Positional: [] };
      Return: () => void;
    }>;
    or: HelperLike<{
      Args: { Positional: unknown[] };
      Return: unknown;
    }>;
    hash: typeof import('@ember/helper').hash;
  }
}

declare global {
  function hash<T extends Record<string, unknown>>(object: T): T;
}
