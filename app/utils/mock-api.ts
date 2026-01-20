let shouldFail = false;

export function setMockFailure(value: boolean): void {
  shouldFail = value;
}

export function getMockFailure(): boolean {
  return shouldFail;
}
