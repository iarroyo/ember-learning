import '@glint/ember-tsc/types';

// Context registry for ember-provide-consume-context
declare module 'ember-provide-consume-context' {
  interface Registry {
    'tabs-context': {
      value: string;
      setValue: (value: string) => void;
    };
  }
}
