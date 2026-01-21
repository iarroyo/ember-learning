import { tracked } from '@glimmer/tracking';

export class AsyncResource<T = unknown> {
  @tracked isLoading = false;
  @tracked isError = false;
  @tracked isSuccess = false;
  @tracked data: T | null = null;
  @tracked error: Error | null = null;
  private abortController: AbortController | null = null;

  constructor(private fetchFn: (signal?: AbortSignal) => Promise<T>) {}

  async load(): Promise<void> {
    this.isLoading = true;
    this.isError = false;
    this.isSuccess = false;
    this.error = null;

    this.abortController = new AbortController();

    try {
      const result = await this.fetchFn(this.abortController.signal);
      this.data = result;
      this.isSuccess = true;
    } catch (err) {
      if (err instanceof DOMException && err.name === 'AbortError') {
        // Cancelled - don't set error state
        this.isLoading = false;
        return;
      }
      this.error = err instanceof Error ? err : new Error(String(err));
      this.isError = true;
    } finally {
      this.isLoading = false;
    }
  }

  retry(): Promise<void> {
    return this.load();
  }

  cancel(): void {
    if (this.abortController) {
      this.abortController.abort();
    }
  }

  reset(): void {
    this.isLoading = false;
    this.isError = false;
    this.isSuccess = false;
    this.data = null;
    this.error = null;
    this.cancel();
  }

  get isEmpty(): boolean {
    return Array.isArray(this.data) && this.data.length === 0;
  }
}
