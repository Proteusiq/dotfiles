# Prayson’s Software Development Manifesto

**Write less code. Leave less to learn. Build secure, correct, simple, and maintainable software.**

<details>
<summary><strong>1. Security by Design</strong> — Security is a boundary, not a feature.</summary>

- Enforce Role-Based Access Control (RBAC) at every document, query, and retrieval boundary.
- Deny access by default.
- Apply least privilege at every trust boundary.
- Never assume that an upstream authorization check protects downstream access paths.
- Validate untrusted inputs and prevent unauthorized access, privilege escalation, and data leakage.
- Never expose secrets or unauthorized data through APIs, logs, caches, or model context.

</details>

<details>
<summary><strong>2. DRY: Single Source of Truth</strong> — Eliminate duplicated knowledge, not necessarily duplicated code.</summary>

- Maintain a single source of truth for each piece of knowledge.
- Avoid independently maintained representations of the same business rule or configuration.
- Tolerate duplicated code until a stable abstraction emerges.
- Never introduce an abstraction merely to eliminate repetition.
- Keep independently changing concepts separate.

</details>

<details>
<summary><strong>3. Explicit Dependencies</strong> — Make dependencies visible, deliberate, and replaceable.</summary>

- Prefer dependency injection over hidden dependencies.
- Make interfaces and dependency direction explicit.
- Design components to be independently testable.
- Keep infrastructure concerns separate from core business logic where practical.
- Avoid unnecessary global state, service locators, and implicit coupling.

</details>

<details>
<summary><strong>4. Functional Programming</strong> — Prefer pure functions, composition, and immutability over unnecessary object-oriented complexity.</summary>

- Keep business logic pure wherever practical.
- Make side effects explicit and isolate them at system boundaries.
- Prefer immutable data when it improves correctness and clarity.
- Use functional composition to build behaviour from small, understandable units.
- Use monads when they simplify composition, error handling, or effect management.
- Use object-oriented techniques when they provide a genuine advantage.

Choose the paradigm that best expresses the problem.

</details>

<details>
<summary><strong>5. Domain-Driven Design</strong> — Let the business domain lead the design.</summary>

- Understand the problem before choosing the architecture.
- Model business concepts, rules, and constraints explicitly.
- Establish a shared, ubiquitous language.
- Use domain terminology consistently in code, tests, APIs, and documentation.
- Keep domain logic cohesive and independent of unnecessary infrastructure concerns.

</details>

<details>
<summary><strong>6. Simplicity Is King</strong> — Choose the simplest solution that satisfies the requirements.</summary>

- Prefer clarity over cleverness.
- Avoid unnecessary abstractions, frameworks, layers, and dependencies.
- Avoid speculative generality and premature optimization.
- Measure before optimizing.
- Prefer proven, well-understood solutions when they fit.
- Do not sacrifice security, correctness, or clarity to reduce code.

</details>

<details>
<summary><strong>7. Less Code, Less to Learn</strong> — Minimize the amount of code and the number of concepts required to understand the system.</summary>

- Every line of code introduces something to understand, test, maintain, and potentially break.
- Prefer existing, proven solutions over custom implementations when appropriate.
- Eliminate unnecessary boilerplate, indirection, and dependencies.
- Avoid compressing code at the expense of readability.
- Optimize for the total complexity an engineer must learn, not the number of characters written.

**The goal is not fewer characters. It is less code to understand.**

</details>

<details>
<summary><strong>8. AHA and YAGNI</strong> — Avoid hasty abstractions. Do not build what is not needed.</summary>

- Let stable patterns emerge before generalizing.
- Prefer duplication over an abstraction that couples unrelated concepts.
- Abstract around genuine shared knowledge and behaviour.
- Solve demonstrated problems before hypothetical future requirements.
- Avoid speculative features and unnecessary extension points.

</details>

<details>
<summary><strong>9. Self-Documenting Code</strong> — Code should communicate its intent through names, types, interfaces, and structure.</summary>

- Choose names that express purpose and domain meaning.
- Make inputs, outputs, dependencies, and contracts explicit.
- Keep functions focused and responsibilities clear.
- Avoid deeply nested logic and unexplained indirection.
- Refactor unnecessary complexity instead of relying on extensive comments.
- Preserve comments that explain non-obvious decisions, constraints, and trade-offs.

</details>

<details>
<summary><strong>10. Standard Technical English (STE)</strong> — Use precise, consistent, and unambiguous technical language.</summary>

- Apply STE to identifiers, interfaces, documentation, error messages, tests, and technical decisions.
- Prefer established terminology over invented synonyms.
- Use consistent names for the same concepts throughout the system.
- Avoid ambiguous abbreviations unless they are established in the domain.
- Write clear API contracts and actionable error messages.
- Make technical communication easy to understand without relying on the original author's explanation.

</details>

<details>
<summary><strong>11. Explicit State and Side Effects</strong> — Make state changes visible and predictable.</summary>

- Avoid hidden state and mutable global variables.
- Prefer explicit inputs and outputs.
- Isolate side effects at well-defined boundaries.
- Make state transitions deliberate and testable.
- Avoid surprising behaviour caused by implicit mutation or shared state.

</details>

<details>
<summary><strong>12. No Magic Numbers</strong> — Every meaningful constant should communicate its purpose.</summary>

- Replace unexplained numeric literals with meaningful named constants where appropriate.
- Name configuration values according to the business or technical rule they represent.
- Keep authoritative configuration in one place.
- Avoid duplicating configuration across modules and environments.
- Do not create constants for trivial values when naming them adds no clarity.

</details>

<details>
<summary><strong>13. Structured Errors and Explicit Failure</strong> — Never silently lose information about a failure.</summary>

- Represent errors explicitly using structured exceptions, result types, or equivalent mechanisms.
- Preserve the original cause and useful diagnostic context.
- Never swallow errors silently.
- Distinguish expected business outcomes from unexpected technical failures.
- Handle errors at the appropriate responsibility boundary.
- Avoid using exceptions as routine control flow when explicit results or ordinary branching are clearer.
- Never expose sensitive information or internal implementation details through user-facing errors.

</details>

<details>
<summary><strong>14. Verification and Testing</strong> — Correctness must be demonstrated, not assumed.</summary>

- Write automated tests for behaviour, business rules, invariants, and edge cases.
- Use test-driven development when it improves feedback and design.
- Test failure paths and authorization boundaries, not only successful scenarios.
- Use integration and property-based testing where they provide meaningful assurance.
- Run relevant tests and quality checks before committing.
- Automate verification through continuous integration.

**If behaviour has not been adequately verified, it is not done.**

</details>

<details>
<summary><strong>15. Observability and Operability</strong> — Design software to be understood while it runs.</summary>

- Use structured logs, metrics, and distributed traces.
- Include useful diagnostic context and correlation identifiers.
- Make failures diagnosable without exposing sensitive information.
- Define appropriate timeouts, retry policies, and idempotency guarantees.
- Design for graceful failure, recovery, and safe operation.
- Establish measurable reliability objectives and actionable alerts.

</details>

<details>
<summary><strong>16. Evolutionary Design</strong> — Organize code so changes are easy and predictable.</summary>

- Maintain high cohesion and low coupling.
- Separate responsibilities that change for different reasons.
- Keep modules understandable without fragmenting the system unnecessarily.
- Refactor continuously while preserving behaviour through tests.
- Design for evolving requirements without speculative complexity.
- Treat maintainability as an architectural property, not a cleanup task for later.

</details>

<details>
<summary><strong>17. Comments and Documentation</strong> — Document intent, contracts, and decisions. Do not narrate obvious code.</summary>

- Use comments to explain why something is needed, not what self-explanatory code already says.
- Document public APIs, including their purpose, inputs, outputs, failure modes, and behavioural guarantees.
- Keep internal helper functions self-explanatory whenever practical.
- Keep documentation close to the code it describes.
- Update documentation when behaviour or contracts change.
- Refactor unnecessarily complicated code before adding comments to explain it.

</details>

<details>
<summary><strong>18. Small, Verified Commits</strong> — Commit early, commit often.</summary>

- Keep commits small, focused, and coherent.
- Make each commit represent an understandable change.
- Run relevant tests and quality checks before committing.
- Avoid mixing unrelated refactoring, formatting, and behavioural changes.
- Write commit messages that communicate intent.
- Keep the codebase in a state that can be understood and built upon safely.

</details>

<details>
<summary><strong>19. Automated Enforcement</strong> — If a standard can be checked mechanically, automate it.</summary>

- Use formatters and linters to enforce consistency.
- Use type checkers and static analysis to catch preventable defects.
- Use automated tests to verify behaviour.
- Use architecture tests to enforce dependency direction and module boundaries.
- Test authorization policies and access-control invariants.
- Run quality gates in continuous integration.
- Reserve human review for judgment, domain understanding, security reasoning, and trade-offs that tools cannot reliably resolve.

</details>

## The Engineering Standard

Every engineering decision should protect and improve six qualities:

1. **Security:** Access is controlled and trust boundaries are explicit.
2. **Correctness:** Behaviour is verified against requirements.
3. **Clarity:** Intent is understandable without the original author.
4. **Simplicity:** Complexity is justified by a real need.
5. **Changeability:** Requirements can evolve without unnecessary disruption.
6. **Operability:** Production behaviour can be understood, diagnosed, and recovered.

No principle should be applied mechanically at the expense of the system. Understand the trade-offs, make decisions deliberately, and choose the solution that produces the most reliable and maintainable result.

## The Ultimate Test

A competent engineer should be able to understand the system, verify its behaviour, diagnose its failures, and change it safely without needing the original author in the room.

**Write less. Think clearly. Verify what matters. Protect the data. Build for change. Leave less to learn.**
