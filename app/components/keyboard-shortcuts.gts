import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import {
  registerDestructor,
  associateDestroyableChild,
} from '@ember/destroyable';
import { modifier } from 'ember-modifier';
import type Owner from '@ember/owner';

// Manager class demonstrating registerDestructor pattern
class KeyboardShortcutManager {
  private handler: (e: KeyboardEvent) => void;

  constructor(owner: object, shortcuts: Map<string, () => void>) {
    this.handler = (e: KeyboardEvent) => {
      const callback = shortcuts.get(e.key);
      if (callback) {
        e.preventDefault();
        callback();
      }
    };

    document.addEventListener('keydown', this.handler);

    // Register cleanup - runs when owner (component) is destroyed
    registerDestructor(this, () => {
      document.removeEventListener('keydown', this.handler);
    });
  }
}

// Modifier demonstrating cleanup return pattern
export const onKeydown = modifier(
  (element: HTMLElement, [key, callback]: [string, () => void]) => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === key) {
        e.preventDefault();
        callback();
      }
    };

    element.addEventListener('keydown', handler);

    // Return cleanup function - runs when element is removed or modifier updates
    return () => {
      element.removeEventListener('keydown', handler);
    };
  }
);

interface KeyboardShortcutsSignature {
  Args: {
    shortcuts: Map<string, () => void>;
    onInit?: () => Promise<void>;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

export class KeyboardShortcuts extends Component<KeyboardShortcutsSignature> {
  @tracked isInitialized = false;
  private manager: KeyboardShortcutManager;

  constructor(owner: Owner, args: KeyboardShortcutsSignature['Args']) {
    super(owner, args);

    // Create manager and associate it as a destroyable child
    this.manager = new KeyboardShortcutManager(this, args.shortcuts);
    associateDestroyableChild(this, this.manager);

    // Run async initialization
    void this.initialize();
  }

  async initialize(): Promise<void> {
    if (this.args.onInit) {
      await this.args.onInit();

      // Check isDestroying before updating state after async operation
      if (this.isDestroying) return;

      this.isInitialized = true;
    } else {
      this.isInitialized = true;
    }
  }

  <template>
    <div data-test-keyboard-shortcuts ...attributes>
      {{yield}}
    </div>
  </template>
}
