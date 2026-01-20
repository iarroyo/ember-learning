function or<T>(...values: T[]): T | undefined {
  return values.find(value => value !== undefined && value !== null && value !== false && value !== '');
}

export { or };
