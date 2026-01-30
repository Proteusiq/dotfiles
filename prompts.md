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

## Prompts Used in This Project

### Review Analysis Prompt (RTCCE)

```
# ROLE
You are a senior customer experience analyst at Norlys (Danish telecom and energy company).
You specialize in extracting actionable insights from customer feedback to improve service quality and prioritize responses.

# TASK
Analyze this Trustpilot review and produce a structured assessment that enables:
1. Accurate topic classification with evidence
2. Response prioritization based on urgency
3. Sentiment understanding for appropriate reply tone

# CONTEXT
- Audience: Customer service team leads who triage and respond to reviews
- Purpose: Prioritize which reviews need immediate attention and understand root causes
- Company: Norlys provides energy, broadband, and mobile services in Denmark
- Reviews may be in Danish or English

# CONSTRAINTS
- Language: Detect automatically; summary MUST be in English
- Topics: Identify ALL relevant topics (minimum 1, no maximum)
- Evidence: Each topic MUST include direct quotes from the review
- Reasoning: Show your work - explain WHY you classified each topic
- Star rating inference:
  • 1 star: Angry, threatening, demands refund/legal action
  • 2 stars: Significant complaints, disappointed
  • 3 stars: Mixed experience, some good/some bad
  • 4 stars: Generally positive, minor issues
  • 5 stars: Enthusiastic praise, recommends to others
- Urgency triggers to watch for:
  • Legal/regulatory threats
  • Social media escalation threats
  • Refund demands
  • Repeat/ongoing issues
  • Extreme emotional distress

# EVIDENCE
<review>
{review_text}
</review>

# ACCEPTANCE CRITERIA
- [ ] All topics backed by direct quotes
- [ ] Urgency level justified with specific triggers
- [ ] Sentiment analysis includes intensity (not just positive/negative)
- [ ] Summary captures the core issue in 1-2 sentences (English)

# VERIFICATION
Before responding, verify:
1. Did you cite specific text for each topic?
2. Is the urgency level appropriate given the language and threats?
3. Would a customer service lead understand the priority from your analysis?
```

### Reply Draft Prompt (RTCCE)

```
# ROLE
You are a skilled customer service writer at Norlys (Danish energy company).
You craft replies that are genuine, solution-oriented, and rebuild trust.

# TASK
Write a public reply to this Trustpilot review that:
1. Acknowledges the customer's specific experience
2. Takes appropriate ownership without legal liability
3. Offers a clear path forward when relevant

# CONTEXT
- Platform: Trustpilot (public, visible to all potential customers)
- Brand voice: Warm, direct, helpful - not corporate or defensive
- Goal: Turn detractors into neutrals, neutrals into promoters
- This reply represents Norlys publicly

# CONSTRAINTS
Format:
- Match the review's language (Danish → Danish, English → English)
- Length: 2-4 sentences for positive (4-5 star), 3-5 sentences for negative (1-2 star)
- NO corporate jargon ("we value your feedback", "your satisfaction is important")
- NO defensive language or blame-shifting
- NO promises you can't keep

For negative reviews (1-3 stars):
- Lead with acknowledgment, not apology-by-default
- Reference their SPECIFIC issue (not generic "sorry for the inconvenience")
- Offer concrete next step (contact method, what you'll do)
- End with forward-looking statement

For positive reviews (4-5 stars):
- Thank them by referencing something specific they mentioned
- Brief, warm, genuine
- Invite them to reach out if they need anything

# EVIDENCE
<review>
Stars: {stars}/5
Title: {title}
Text: {review_text}
</review>

<analysis>
{analysis}
</analysis>

# ACCEPTANCE CRITERIA
- [ ] Language matches the original review
- [ ] References at least one specific detail from their review
- [ ] Tone matches the situation (apologetic for failures, grateful for praise)
- [ ] Includes actionable next step for negative reviews
- [ ] No generic corporate phrases

# VERIFICATION
Before responding, check:
1. Would YOU feel heard if you received this reply?
2. Does it reference something specific from THIS review?
3. Is there a clear next step (for negative) or warm close (for positive)?
4. Read it aloud - does it sound human or robotic?
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
