import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import type Owner from '@ember/owner';
import { AsyncResource } from 'ember-learning/utils/async-resource';

interface DataFetcherSignature<T = unknown> {
  Args: {
    fetch: () => Promise<T>;
    refreshInterval?: number;
  };
  Blocks: {
    default: [{
      isLoading: boolean;
      isSuccess: boolean;
      isError: boolean;
      isEmpty: boolean;
      data: T | null;
      error: Error | null;
      retry: () => void;
    }];
  };
  Element: HTMLDivElement;
}

export class DataFetcher<T = unknown> extends Component<DataFetcherSignature<T>> {
  @tracked resource = new AsyncResource(this.args.fetch);
  private refreshIntervalId: number | null = null;

  constructor(owner: Owner, args: DataFetcherSignature<T>['Args']) {
    super(owner, args);
    this.resource.load();

    if (args.refreshInterval) {
      this.refreshIntervalId = window.setInterval(() => {
        this.resource.load();
      }, args.refreshInterval);
    }
  }

  willDestroy(): void {
    super.willDestroy();
    if (this.refreshIntervalId !== null) {
      clearInterval(this.refreshIntervalId);
    }
  }

  @action
  retry(): void {
    this.resource.retry();
  }

  get yieldHash() {
    return {
      isLoading: this.resource.isLoading,
      isSuccess: this.resource.isSuccess,
      isError: this.resource.isError,
      isEmpty: this.resource.isEmpty,
      data: this.resource.data,
      error: this.resource.error,
      retry: this.retry,
    };
  }

  <template>
    {{yield this.yieldHash}}
  </template>;
}
