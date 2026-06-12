---
description: Detect LLM Fan-Out queries (high impressions, near-zero clicks, Pos 1-10)
argument-hint: "<domain or sc-domain:domain>"
---

You are running an LLM Fan-Out Visibility audit for: **$ARGUMENTS**

Background (Sections 7, 8, 8B of the knowledge base):
- LLMs (ChatGPT, Perplexity, Claude) decompose user prompts into 3-5+ sub-queries
- They Google these sub-queries (not their own index)
- If your page ranks Pos 1-10 for a Fan-Out query AND has 0 clicks, you're being used as Supporting Evidence — but the user clicked through the LLM answer, not through Google
- This is INVISIBLE traffic from an SEO perspective but it's LLM citations (= brand mentions in AI)
- David Quaid's signature: "evaluate", "compare", "vs", "alternative" queries with very long phrasing and 0 CTR

## Execute

### Step 1: Pull suspicious query patterns
Call `mcp__gsc__advanced_search_analytics`:
- dimensions=["query"]
- filters with regex pattern: evaluate|compare|alternative|\bvs\b|versus|best for|which is
- days=28
- order_by: impressions descending
- row_limit=200

### Step 2: Filter to Fan-Out signature
In post-processing keep only queries matching ALL:
- Position <= 10 (you're in the ranked results)
- Clicks <= 1 (no human is clicking)
- Impressions >= 5 (enough signal to not be noise)
- Query length >= 6 words (Fan-Outs are typically long-form)

### Step 3: Cross-validate with DataForSEO intent
For the top-20 candidates, call `mcp__dataforseo__dataforseo_labs_search_intent`.

Expected intent distribution for LLM Fan-Outs:
- ~70% "informational"
- ~25% "commercial"
- ~5% "navigational"

If something is "transactional" and matches Fan-Out signature, flag as anomaly (humans usually click on transactional).

### Step 4: Group by topic
Cluster the Fan-Out queries by semantic theme: comparison-prompts, evaluation-prompts, alternative-prompts, best-for prompts.

### Step 5: Map to source pages
Run `mcp__gsc__advanced_search_analytics` again with dimensions=["query", "page"] filtered to the Fan-Out queries.

For each landing page that consistently catches Fan-Outs, note: "This page is your LLM ambassador for topic X."

## Output Format

Summary stats + two tables: "Top LLM Ambassador Pages" and "Top Fan-Out Queries".

Below 1-paragraph recommendation:
- If you have ambassador pages: name them, suggest expanding their intent-cluster coverage (Section 7 — define, compare, edge cases, next steps)
- Track LLM CTR via GA4 referrer "chatgpt.com", "perplexity.ai", "claude.ai"
- Optional: suggest 1-2 Press Releases (Section 22) to push specific brand mentions into LLM training data

## Cost
~$0.02 per audit.
