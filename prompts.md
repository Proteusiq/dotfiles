# Prompt Engineering Guide

> [Emilie's Prompting Playbook](https://www.linkedin.com/in/emilielundblad/) — based on her [prompting article](https://www.linkedin.com/pulse/all-you-need-know-prompt-better-emilie-lundblad-mx6ne/)

## Frameworks

### RTCCE (for serious work)
| Component | Question to Answer |
|-----------|-------------------|
| **Role** | Who should the AI be? |
| **Task** | What should it do? |
| **Context** | For whom, why, and with what inputs? |
| **Constraints** | What are the rules? |
| **Evidence** | What should it ground on? |

### CLEAR (easy to teach)
| Component | Purpose |
|-----------|---------|
| **Context** | Background information |
| **Language** | Tone and style |
| **Examples** | Show what you want |
| **Ask** | The specific request |
| **Review** | Self-check instructions |

### GCCAV (for agents/workflows)
| Component | Purpose |
|-----------|---------|
| **Goal** | What to achieve |
| **Context** | Background and inputs |
| **Constraints** | Rules and limits |
| **Acceptance** | How to know it's done |
| **Verification** | Self-check steps |

End agent prompts with: *"Plan first. Execute step-by-step. End with verification vs acceptance criteria + what changed + clarifying questions."*

---

## The 5 Principles

### 1. Name the Deliverable
Bad: "Summarize this."
Better: "Write a 1-page brief: TL;DR, decisions, risks, next actions."

### 2. Put Constraints in Writing
- **Length**: "≤150 words"
- **Format**: "table + bullets"
- **Do/Don't**: "no personal data", "no jargon"
- **Tone**: "direct, practical, slightly opinionated"

### 3. Ground on Evidence
- Point to specific files/docs/data
- Paste relevant content
- Be explicit: "use ONLY this" or "web-only"

### 4. Define "Done" with Acceptance Criteria
Examples:
- "Includes 3 options + recommendation"
- "Risks + mitigations included"
- "Cites sources used"
- "All tests pass; coverage ≥90%"

### 5. Require Verification
Add one of these:
- "List assumptions."
- "Flag missing info."
- "Validate against the acceptance criteria."
- "If uncertain, ask clarifying questions first."

---

## Prompt Checklist

Before hitting enter:

- [ ] Did I name the deliverable?
- [ ] Did I specify the audience?
- [ ] Did I provide evidence (or say web-only/general)?
- [ ] Did I state constraints?
- [ ] Did I define acceptance criteria?
- [ ] Did I ask for verification?

---

## Example Prompts

### Example: Code Review Prompt (RTCCE)

```
# ROLE
You are a senior Python developer at Fox's Den (legal tech company).
You specialize in reviewing code for legal software systems where accuracy and security are critical.

# TASK
Review this Python code and produce a structured assessment that enables:
1. Identification of bugs, security issues, and code smells
2. Prioritization of fixes based on severity
3. Actionable recommendations with code examples

# CONTEXT
- Audience: Junior to mid-level Python developers on the team
- Purpose: Catch issues before merge, educate developers, maintain code quality
- Domain: Legal tech - handling sensitive client data, contracts, and case management
- Stack: Python 3.11+, FastAPI, SQLAlchemy, Pydantic

# CONSTRAINTS
- Security: Flag ANY potential data leaks, SQL injection, or auth bypasses as CRITICAL
- Performance: Note O(n²) or worse algorithms on collections > 100 items
- Style: Follow PEP 8, prefer type hints, use dataclasses/Pydantic for data structures
- Testing: Flag untested edge cases, especially around legal document parsing
- Severity levels:
  • CRITICAL: Security vulnerabilities, data loss risks, crashes
  • HIGH: Bugs that affect correctness, missing error handling
  • MEDIUM: Code smells, performance issues, missing tests
  • LOW: Style issues, minor refactoring opportunities

# EVIDENCE
<code>
{code}
</code>

# ACCEPTANCE CRITERIA
- [ ] All issues include line numbers and specific code references
- [ ] Each issue has a severity level with justification
- [ ] Recommendations include corrected code snippets
- [ ] Security implications explicitly called out for legal data handling

# VERIFICATION
Before responding, verify:
1. Did you check for common security vulnerabilities (injection, auth, data exposure)?
2. Are all severity ratings appropriate for a legal tech context?
3. Would a junior developer understand how to fix each issue?
```

### Example: Feature Implementation Prompt (RTCCE)

```
# ROLE
You are a senior Python developer at Fox's Den (legal tech company).
You write clean, secure, well-tested code for legal software systems.

# TASK
Implement a Python feature that:
1. Meets the specified requirements
2. Handles edge cases and errors gracefully
3. Includes comprehensive tests

# CONTEXT
- Codebase: Legal case management system
- Stack: Python 3.11+, FastAPI, SQLAlchemy, Pydantic, pytest
- Standards: Type hints required, 90%+ test coverage, docstrings for public APIs
- Security: All code handles sensitive legal data - privacy and audit trails are critical

# CONSTRAINTS
Format:
- Use type hints for all function signatures
- Use Pydantic models for request/response validation
- Use SQLAlchemy 2.0 style queries
- NO raw SQL strings (use parameterized queries only)
- NO print statements (use structured logging)

Error handling:
- Raise specific exceptions, not generic Exception
- Include context in error messages (without leaking sensitive data)
- Log errors with correlation IDs for audit trails

Testing:
- Unit tests for all public functions
- Integration tests for API endpoints
- Test edge cases: empty inputs, invalid data, permissions

# EVIDENCE
<requirements>
{requirements}
</requirements>

<existing_code>
{existing_code}
</existing_code>

# ACCEPTANCE CRITERIA
- [ ] All functions have type hints and docstrings
- [ ] Pydantic models validate all external inputs
- [ ] No raw SQL or string interpolation in queries
- [ ] Error handling doesn't leak sensitive information
- [ ] Tests cover happy path + at least 3 edge cases
- [ ] Code passes mypy and ruff checks

# VERIFICATION
Before responding, check:
1. Does the code handle malformed or malicious input safely?
2. Are there any places where sensitive data could be logged or exposed?
3. Would this code pass a security audit for legal software?
4. Are the tests actually testing behavior, not just implementation?
```

---

## Quick Hack: Meta-Prompt

Use this to generate prompts for any task:

```
You are an expert in writing prompt instructions with the RTCCE framework.
Write the perfect instruction for {YOUR_TASK}.

CONTEXT DUMP:
- Role: ...
- Task: ...
- Context: audience, goal, why now, inputs
- Constraints: format, length, do/don't, privacy, allowed tools/sources
- Evidence: use ONLY these docs/emails/files/links OR web-only
- Output: exact sections to return
- Review: self-check + assumptions + open questions
```

---

## Maturity Levels

| Level | Name | Description |
|-------|------|-------------|
| 1 | Ask | Type a question, get something |
| 2 | Direct | Specify deliverable, format, audience, constraints |
| 3 | Orchestrate | Add sources, acceptance criteria, self-check |
| 4 | Direct Agents | Delegate workflow: plan → execute → verify → audit trail |

**Move from Level 1 → 2 today for better results.**
**Level 3-4 is where teams win at scale.**
