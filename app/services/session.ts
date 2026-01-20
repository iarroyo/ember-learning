import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import type { Transition } from '@ember/routing/transition';
import { waitForPromise } from '@ember/test-waiters';

export interface User {
  email: string;
  name: string;
}

export default class SessionService extends Service {
  @tracked isAuthenticated = false;
  @tracked currentUser: User | null = null;
  @tracked token: string | null = null;
  attemptedTransition: Transition | null = null;

  async login(credentials: { email: string; password: string }): Promise<void> {
    // Mock login - in real app this would call an API
    if (credentials.email === 'user@example.com' && credentials.password === 'password123') {
      // Simulate network latency for testing loading states
      // Use waitForPromise so test helpers wait for this to complete
      await waitForPromise(new Promise(resolve => setTimeout(resolve, 50)));

      const token = btoa(`${credentials.email}:${Date.now()}`);
      this.token = token;
      this.currentUser = {
        email: credentials.email,
        name: 'John Doe'
      };
      this.isAuthenticated = true;
      localStorage.setItem('auth-token', token);
    } else {
      throw new Error('Invalid email or password');
    }
  }

  logout(): void {
    this.isAuthenticated = false;
    this.currentUser = null;
    this.token = null;
    localStorage.removeItem('auth-token');
  }

  async restoreSession(): Promise<void> {
    const token = localStorage.getItem('auth-token');
    if (!token) {
      return;
    }

    try {
      // Decode token to get email
      const decoded = atob(token);
      const [email] = decoded.split(':');
      
      if (email) {
        this.token = token;
        this.currentUser = {
          email,
          name: 'John Doe'
        };
        this.isAuthenticated = true;
      } else {
        localStorage.removeItem('auth-token');
      }
    } catch {
      // Invalid token
      localStorage.removeItem('auth-token');
    }
  }
}
