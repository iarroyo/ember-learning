import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

import type Owner from '@ember/owner';

export type Theme = 'light' | 'dark' | 'system';

export default class ThemeService extends Service {
  @tracked theme: Theme = 'system';

  constructor(owner: Owner) {
    super(owner);
    this.loadTheme();
    this.applyTheme();
    this.setupSystemThemeListener();
  }

  get isDark(): boolean {
    if (this.theme === 'system') {
      return window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    return this.theme === 'dark';
  }

  @action
  setTheme(theme: Theme): void {
    this.theme = theme;
    localStorage.setItem('theme', theme);
    this.applyTheme();
  }

  @action
  toggle(): void {
    const newTheme = this.isDark ? 'light' : 'dark';
    this.setTheme(newTheme);
  }

  private loadTheme(): void {
    const stored = localStorage.getItem('theme') as Theme | null;
    if (stored && ['light', 'dark', 'system'].includes(stored)) {
      this.theme = stored;
    }
  }

  private applyTheme(): void {
    const root = document.documentElement;
    if (this.isDark) {
      root.classList.add('dark');
    } else {
      root.classList.remove('dark');
    }
  }

  private setupSystemThemeListener(): void {
    window
      .matchMedia('(prefers-color-scheme: dark)')
      .addEventListener('change', () => {
        if (this.theme === 'system') {
          this.applyTheme();
        }
      });
  }
}

declare module '@ember/service' {
  interface Registry {
    theme: ThemeService;
  }
}
