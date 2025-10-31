# Python Project Conventions

## Development Workflow

### Tool Execution
- Use `uv run` for all script and command execution
- Always run formatters and linters before committing:
  ```bash
  uv format
  uv check --fix
  ```
- Verify all tests pass with `uv run pytest`
- If tests fail, fix them before proceeding with other changes

## Code Style

### Documentation
- Use Google-style docstrings for all public functions, classes, and modules
- Avoid tutorial-style `#` comments that explain what code does
- Comments should explain **why**, not **what** (the code itself should be self-explanatory)
- Example:
  ```python
  def process_items(items: list[Item]) -> list[Result]:
      """Process items and return results.
      
      Args:
          items: List of items to process.
          
      Returns:
          List of processed results.
          
      Raises:
          ValueError: If items list is empty.
      """
      # Use batch processing for performance with large datasets
      return await batch_process(items)
  ```

### Type Annotations
- Fully type-annotate all functions, methods, and variables
- Target Python 3.12+ syntax:
  - Use `list[T]`, `dict[K, V]`, `set[T]` (not `List`, `Dict`, `Set` from typing)
  - Use `X | Y` for unions (not `Union[X, Y]`)
  - Use `X | None` for optional types (not `Optional[X]`)
- Example:
  ```python
  def fetch_data(url: str, timeout: float = 30.0) -> dict[str, Any] | None:
      ...
  ```

### Programming Paradigm
- Prefer functional programming patterns over OOP when appropriate
- Use the best tool for the job (don't force FP or OOP dogmatically)
- Favor immutability and pure functions where practical
- Prefer composition over inheritance
- Use dataclasses or Pydantic models for data structures

### Asynchronous Code
- Prefer `async`/`await` for I/O-bound operations
- Use `asyncio` patterns consistently
- Consider `aiohttp`, `httpx`, or similar for HTTP requests
- Always await coroutines properly
- Example:
  ```python
  async def fetch_multiple(urls: list[str]) -> list[dict[str, Any]]:
      """Fetch data from multiple URLs concurrently."""
      async with httpx.AsyncClient() as client:
          tasks = [client.get(url) for url in urls]
          responses = await asyncio.gather(*tasks)
          return [r.json() for r in responses]
  ```

### Performance
- Write code with performance in mind
- Profile before optimizing
- Use appropriate data structures (sets for membership, deques for queues, etc.)
- Leverage list/dict/set comprehensions over explicit loops when clearer
- Consider generators for memory efficiency with large datasets

## Testing

### Test Execution
- Run tests with `uv run pytest`
- All tests must pass before pushing code
- Fix broken tests immediately—do not commit failing tests

### Test Style
- Follow the same conventions as production code
- Use descriptive test names that explain the scenario
- Prefer `async` tests for async code using `pytest-asyncio`
- Example:
  ```python
  @pytest.mark.asyncio
  async def test_fetch_data_returns_valid_json():
      """Test that fetch_data returns properly formatted JSON."""
      result = await fetch_data("https://api.example.com/data")
      assert isinstance(result, dict)
      assert "id" in result
  ```

## Code Organization

### Module Structure
- Keep modules focused and cohesive
- Prefer many small modules over few large ones
- Use clear, descriptive names
- Organize imports: stdlib, third-party, local (separated by blank lines)

### Function Design
- Keep functions small and single-purpose
- Use descriptive names (prefer `calculate_total_price` over `calc`)
- Limit arguments (consider using dataclasses for many parameters)
- Return early to reduce nesting

## Summary

**Remember:** Write code that is clear, fast, and well-typed. Let the code speak for itself with minimal comments. Use async for I/O. Run formatters, linters, and tests before committing.
