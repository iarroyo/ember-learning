import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export interface ProfileData {
  firstName: string;
  lastName: string;
  email: string;
  bio: string;
}

interface ProfileEditorSignature {
  Args: {
    mode: 'object' | 'granular';
    onSave?: (profile: ProfileData) => void;
  };
  Element: HTMLFormElement;
}

// Helper to track render count - increments each time it's called in template
let renderCounters = new WeakMap<object, number>();

function getRenderCount(component: object): number {
  const current = renderCounters.get(component) ?? 0;
  const next = current + 1;
  renderCounters.set(component, next);
  return next;
}

/**
 * Profile Editor demonstrating two reactivity patterns:
 *
 * 1. "object" mode - Single tracked object (anti-pattern)
 *    - All state in one @tracked object
 *    - Must reassign entire object on every change
 *    - All consumers re-render on any field change
 *
 * 2. "granular" mode - Individual tracked properties (recommended)
 *    - Each field is its own @tracked property
 *    - Simple direct assignment
 *    - Only affected consumers re-render
 */
export class ProfileEditor extends Component<ProfileEditorSignature> {
  // ============================================
  // OBJECT MODE: Single tracked object state
  // ============================================
  @tracked objectState = {
    firstName: '',
    lastName: '',
    email: '',
    bio: '',
  };

  // ============================================
  // GRANULAR MODE: Individual tracked properties
  // ============================================
  @tracked firstName = '';
  @tracked lastName = '';
  @tracked email = '';
  @tracked bio = '';

  // ============================================
  // Derived state (works with both modes)
  // ============================================
  get fullName(): string {
    if (this.args.mode === 'object') {
      return `${this.objectState.firstName} ${this.objectState.lastName}`.trim();
    }
    return `${this.firstName} ${this.lastName}`.trim();
  }

  get isValid(): boolean {
    if (this.args.mode === 'object') {
      return (
        this.objectState.firstName.length > 0 &&
        this.objectState.email.includes('@')
      );
    }
    return this.firstName.length > 0 && this.email.includes('@');
  }

  get profileData(): ProfileData {
    if (this.args.mode === 'object') {
      return { ...this.objectState };
    }
    return {
      firstName: this.firstName,
      lastName: this.lastName,
      email: this.email,
      bio: this.bio,
    };
  }

  // Track render count for visualization
  get renderCount(): number {
    // This getter is called during render, so we use it to track renders
    // In object mode, reading objectState triggers on any field change
    // In granular mode, we read all fields to show fair comparison
    if (this.args.mode === 'object') {
      // Access the tracked object to establish dependency
      void this.objectState;
    } else {
      // Access all tracked properties to establish dependencies
      void this.firstName;
      void this.lastName;
      void this.email;
      void this.bio;
    }
    return getRenderCount(this);
  }

  // ============================================
  // OBJECT MODE: Update handlers (verbose!)
  // ============================================
  @action
  updateObjectFirstName(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    // ❌ Must spread and reassign entire object
    this.objectState = { ...this.objectState, firstName: value };
  }

  @action
  updateObjectLastName(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.objectState = { ...this.objectState, lastName: value };
  }

  @action
  updateObjectEmail(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.objectState = { ...this.objectState, email: value };
  }

  @action
  updateObjectBio(event: Event): void {
    const value = (event.target as HTMLTextAreaElement).value;
    this.objectState = { ...this.objectState, bio: value };
  }

  // ============================================
  // GRANULAR MODE: Update handlers (simple!)
  // ============================================
  @action
  updateFirstName(event: Event): void {
    // ✅ Simple direct assignment
    this.firstName = (event.target as HTMLInputElement).value;
  }

  @action
  updateLastName(event: Event): void {
    this.lastName = (event.target as HTMLInputElement).value;
  }

  @action
  updateEmail(event: Event): void {
    this.email = (event.target as HTMLInputElement).value;
  }

  @action
  updateBio(event: Event): void {
    this.bio = (event.target as HTMLTextAreaElement).value;
  }

  // ============================================
  // Common handlers
  // ============================================
  @action
  handleSubmit(event: Event): void {
    event.preventDefault();
    if (this.isValid && this.args.onSave) {
      this.args.onSave(this.profileData);
    }
  }

  @action
  resetForm(): void {
    if (this.args.mode === 'object') {
      this.objectState = { firstName: '', lastName: '', email: '', bio: '' };
    } else {
      this.firstName = '';
      this.lastName = '';
      this.email = '';
      this.bio = '';
    }
  }

  <template>
    <form
      data-test-profile-editor
      data-test-mode={{@mode}}
      class="p-4 border rounded-lg bg-white"
      {{on "submit" this.handleSubmit}}
      ...attributes
    >
      <div class="mb-4">
        <h3 class="text-lg font-semibold mb-1">
          {{if (eq @mode "object") "Object Mode (Anti-pattern)" "Granular Mode (Recommended)"}}
        </h3>
        <p class="text-sm text-gray-500">
          {{if (eq @mode "object")
            "Single @tracked object - must reassign on every change"
            "Individual @tracked properties - simple direct assignment"
          }}
        </p>
      </div>

      <div class="mb-4 p-2 bg-gray-100 rounded">
        <span class="text-sm font-medium">Render count: </span>
        <span data-test-render-count class="font-mono text-blue-600">
          {{this.renderCount}}
        </span>
      </div>

      <div class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            First Name
          </label>
          {{#if (eq @mode "object")}}
            <input
              data-test-first-name
              type="text"
              value={{this.objectState.firstName}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateObjectFirstName}}
            />
          {{else}}
            <input
              data-test-first-name
              type="text"
              value={{this.firstName}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateFirstName}}
            />
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Last Name
          </label>
          {{#if (eq @mode "object")}}
            <input
              data-test-last-name
              type="text"
              value={{this.objectState.lastName}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateObjectLastName}}
            />
          {{else}}
            <input
              data-test-last-name
              type="text"
              value={{this.lastName}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateLastName}}
            />
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Email
          </label>
          {{#if (eq @mode "object")}}
            <input
              data-test-email
              type="email"
              value={{this.objectState.email}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateObjectEmail}}
            />
          {{else}}
            <input
              data-test-email
              type="email"
              value={{this.email}}
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateEmail}}
            />
          {{/if}}
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Bio
          </label>
          {{#if (eq @mode "object")}}
            <textarea
              data-test-bio
              value={{this.objectState.bio}}
              rows="3"
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateObjectBio}}
            ></textarea>
          {{else}}
            <textarea
              data-test-bio
              value={{this.bio}}
              rows="3"
              class="w-full px-3 py-2 border rounded"
              {{on "input" this.updateBio}}
            ></textarea>
          {{/if}}
        </div>

        <div class="p-2 bg-blue-50 rounded">
          <span class="text-sm font-medium">Full Name (derived): </span>
          <span data-test-full-name class="text-blue-800">
            {{if this.fullName this.fullName "(empty)"}}
          </span>
        </div>

        <div class="flex gap-2">
          <button
            data-test-save-button
            type="submit"
            disabled={{not this.isValid}}
            class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            Save Profile
          </button>
          <button
            data-test-reset-button
            type="button"
            class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
            {{on "click" this.resetForm}}
          >
            Reset
          </button>
        </div>
      </div>
    </form>
  </template>
}

// Helper for template
function eq(a: unknown, b: unknown): boolean {
  return a === b;
}

function not(value: unknown): boolean {
  return !value;
}
