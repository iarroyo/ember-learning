function noop(): () => void {
  return () => {
    // No operation
  };
}

export { noop };
