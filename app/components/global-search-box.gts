import Component from '@glimmer/component';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import type GlobalSearchService from 'ember-learning/services/global-search';

interface GlobalSearchBoxSignature {
  Args: {
    placeholder?: string;
  };
  Element: HTMLDivElement;
}

export class GlobalSearchBox extends Component<GlobalSearchBoxSignature> {
  @service declare globalSearch: GlobalSearchService;

  get placeholder(): string {
    return this.args.placeholder ?? 'Global search...';
  }

  get results() {
    return this.globalSearch.results;
  }

  get isLoading(): boolean {
    return this.globalSearch.isSearching;
  }

  get hasResults(): boolean {
    return this.results.length > 0;
  }

  get searchHistory() {
    return this.globalSearch.searchHistory;
  }

  @action
  handleInput(event: Event): void {
    const query = (event.target as HTMLInputElement).value;
    void this.globalSearch.searchTask.perform(query);
  }

  @action
  cancel(): void {
    // This cancels the shared task - affects ALL GlobalSearchBox components!
    this.globalSearch.cancelAllSearches();
  }

  @action
  clearHistory(): void {
    this.globalSearch.clearHistory();
  }

  <template>
    <div data-test-global-search-box role="search" ...attributes>
      <div class="flex gap-2">
        <input
          data-test-search-input
          type="search"
          placeholder={{this.placeholder}}
          aria-label={{this.placeholder}}
          class="flex-1 px-3 py-2 border rounded"
          {{on "input" this.handleInput}}
        />
        {{#if this.isLoading}}
          <button
            data-test-search-cancel
            type="button"
            class="px-3 py-2 bg-gray-200 rounded"
            aria-label="Cancel search"
            {{on "click" this.cancel}}
          >
            Cancel
          </button>
        {{/if}}
      </div>

      <div aria-live="polite" aria-atomic="true">
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
            <ul class="mt-1 space-y-1" role="list" aria-label="Search results">
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

      {{#if this.searchHistory.length}}
        <div class="mt-4 pt-4 border-t">
          <div class="flex justify-between items-center">
            <span
              data-test-history-label
              id="search-history-label"
              class="text-sm font-medium text-gray-700"
            >
              Search History ({{this.searchHistory.length}})
            </span>
            <button
              data-test-clear-history
              type="button"
              class="text-xs text-gray-500 hover:text-gray-700"
              aria-label="Clear search history"
              {{on "click" this.clearHistory}}
            >
              Clear
            </button>
          </div>
          <ul
            class="mt-1 space-y-1"
            role="list"
            aria-labelledby="search-history-label"
          >
            {{#each this.searchHistory as |entry|}}
              <li data-test-history-entry class="text-sm text-gray-600">
                "{{entry.query}}" -
                {{entry.resultCount}}
                results
              </li>
            {{/each}}
          </ul>
        </div>
      {{/if}}
    </div>
  </template>
}
