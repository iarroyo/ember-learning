import { buildWaiter } from '@ember/test-waiters';
import { registerDestructor } from '@ember/destroyable';

// Create a waiter with a descriptive name for debugging
const waiter = buildWaiter('debounced-search:search');

export class DebouncedSearch {
  private timeoutId: ReturnType<typeof setTimeout> | null = null;
  private currentToken: unknown = null;

  constructor(owner?: object) {
    // If an owner is provided, register cleanup
    if (owner) {
      registerDestructor(this, () => {
        this.cancel();
      });
    }
  }

  /**
   * Perform a debounced search operation.
   * Uses buildWaiter to ensure tests wait for the debounced callback.
   */
  search(
    query: string,
    callback: (query: string) => Promise<void>,
    delay = 300
  ): void {
    // Cancel any pending search
    this.cancel();

    // Begin async operation - tests will wait for this
    this.currentToken = waiter.beginAsync();

    this.timeoutId = setTimeout(async () => {
      // Clear timeout ID since we're now executing
      this.timeoutId = null;
      try {
        await callback(query);
      } finally {
        // Always end the async operation
        if (this.currentToken) {
          waiter.endAsync(this.currentToken);
          this.currentToken = null;
        }
      }
    }, delay);
  }

  /**
   * Cancel any pending search operation.
   */
  cancel(): void {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
      this.timeoutId = null;
    }

    // End any pending async operation
    if (this.currentToken) {
      waiter.endAsync(this.currentToken);
      this.currentToken = null;
    }
  }

  /**
   * Check if a search is pending.
   */
  get isPending(): boolean {
    return this.timeoutId !== null;
  }
}
