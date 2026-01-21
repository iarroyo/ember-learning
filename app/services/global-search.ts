import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { task, timeout } from 'ember-concurrency';

export interface SearchResult {
  id: string;
  title: string;
  description?: string;
}

export interface SearchHistoryEntry {
  query: string;
  timestamp: Date;
  resultCount: number;
}

// Mock search function - in real app this would call an API
async function mockSearch(query: string): Promise<SearchResult[]> {
  // Simulate network delay
  await new Promise((resolve) => setTimeout(resolve, 300));

  if (!query.trim()) {
    return [];
  }

  // Return mock results based on query
  return [
    { id: '1', title: `Global result for "${query}" #1` },
    { id: '2', title: `Global result for "${query}" #2` },
  ];
}

export default class GlobalSearchService extends Service {
  @tracked searchHistory: SearchHistoryEntry[] = [];

  // This task is SHARED across all components that inject this service
  // Calling cancelAll() from ANY component will cancel for ALL components
  searchTask = task({ restartable: true }, async (query: string) => {
    // Debounce
    await timeout(300);

    const results = await mockSearch(query);

    // Track in history
    this.searchHistory = [
      ...this.searchHistory,
      {
        query,
        timestamp: new Date(),
        resultCount: results.length,
      },
    ];

    return results;
  });

  // Convenience getters
  get results(): SearchResult[] {
    return this.searchTask.lastSuccessful?.value ?? [];
  }

  get isSearching(): boolean {
    return this.searchTask.isRunning;
  }

  get lastQuery(): string | undefined {
    const last = this.searchHistory[this.searchHistory.length - 1];
    return last?.query;
  }

  // Cancel all running searches - affects ALL consumers of this service
  cancelAllSearches(): void {
    void this.searchTask.cancelAll();
  }

  clearHistory(): void {
    this.searchHistory = [];
  }
}
