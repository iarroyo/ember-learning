import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { task, timeout } from 'ember-concurrency';

export interface SearchResult {
  id: string;
  title: string;
  description?: string;
}

interface SearchBoxSignature {
  Args: {
    onResults?: (results: SearchResult[]) => void;
    placeholder?: string;
    debounceMs?: number;
  };
  Element: HTMLDivElement;
}

// Mock search function - in real app this would call an API
async function mockSearch(query: string): Promise<SearchResult[]> {
  // Simulate network delay
  await new Promise((resolve) => setTimeout(resolve, 200));

  if (!query.trim()) {
    return [];
  }

  // Return mock results based on query
  return [
    { id: '1', title: `Result for "${query}" #1`, description: 'First result' },
    {
      id: '2',
      title: `Result for "${query}" #2`,
      description: 'Second result',
    },
    { id: '3', title: `Result for "${query}" #3`, description: 'Third result' },
  ];
}

export class SearchBox extends Component<SearchBoxSignature> {
  get placeholder(): string {
    return this.args.placeholder ?? 'Search...';
  }

  get debounceMs(): number {
    return this.args.debounceMs ?? 300;
  }

  // Task is defined on the component instance - each component has its own
  // Using restartable: if user types again, cancel previous search and start new one
  searchTask = task({ restartable: true }, async (query: string) => {
    // Debounce - wait before actually searching
    await timeout(this.debounceMs);

    const results = await mockSearch(query);

    // Notify parent if callback provided
    if (this.args.onResults) {
      this.args.onResults(results);
    }

    return results;
  });

  // Get results from lastSuccessful to show stale data while loading
  get results(): SearchResult[] {
    return this.searchTask.lastSuccessful?.value ?? [];
  }

  get isLoading(): boolean {
    return this.searchTask.isRunning;
  }

  get hasResults(): boolean {
    return this.results.length > 0;
  }

  @action
  handleInput(event: Event): void {
    const query = (event.target as HTMLInputElement).value;
    void this.searchTask.perform(query);
  }

  @action
  cancel(): void {
    // Only cancels THIS component's task instance
    // Does NOT affect other SearchBox components
    void this.searchTask.cancelAll();
  }

  <template>
    <div data-test-search-box ...attributes>
      <div class="flex gap-2">
        <input
          data-test-search-input
          type="text"
          placeholder={{this.placeholder}}
          class="flex-1 px-3 py-2 border rounded"
          {{on "input" this.handleInput}}
        />
        {{#if this.isLoading}}
          <button
            data-test-search-cancel
            type="button"
            class="px-3 py-2 bg-gray-200 rounded"
            {{on "click" this.cancel}}
          >
            Cancel
          </button>
        {{/if}}
      </div>

      {{#if this.isLoading}}
        <div data-test-search-loading class="mt-2 text-gray-500">
          Searching...
        </div>
      {{/if}}

      {{#if this.hasResults}}
        <div class="mt-2">
          <div data-test-search-results-count class="text-sm text-gray-500">
            {{this.results.length}}
            results
          </div>
          <ul class="mt-1 space-y-1">
            {{#each this.results as |result|}}
              <li data-test-search-result class="p-2 bg-gray-50 rounded">
                <div class="font-medium">{{result.title}}</div>
                {{#if result.description}}
                  <div
                    class="text-sm text-gray-500"
                  >{{result.description}}</div>
                {{/if}}
              </li>
            {{/each}}
          </ul>
        </div>
      {{/if}}
    </div>
  </template>
}
