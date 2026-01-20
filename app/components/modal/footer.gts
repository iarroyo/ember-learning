import type { TOC } from '@ember/component/template-only';

export interface ModalFooterSignature {
  Args: Record<string, never>;
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

const ModalFooter = <TOC<ModalFooterSignature>>(
  <template>
    <div data-test-modal-footer>
      {{yield}}
    </div>
  </template>
);

export { ModalFooter };
