---
description: Discover semantic neighbor keywords to expand topical authority around a seed keyword
argument-hint: "<seed-keyword> [domain]"
---

You are running Topical Cluster Expansion for seed keyword: **$ARGUMENTS**

Background (Sections 1, 5, 7, 18 of the knowledge base):
- Topical Authority builds by ranking, getting clicks, expanding into adjacent topics
- "Topical Bridges" exist: queries that overlap in user behavior even if semantically distant
- Don't write 2000-word articles for unproven keywords — use Thin Starter Pages (200-400 words) and let GSC tell you what to expand

If second argument is provided, treat it as the target domain. Otherwise use the default GSC property.

## Execute

### Step 1: Get the semantic candidate pool
Run in parallel:
- `mcp__dataforseo__dataforseo_labs_google_related_keywords` (seed = first arg, location_name="United States", language_code="en", limit=100)
- `mcp__dataforseo__dataforseo_labs_google_keyword_ideas` (keywords=[seed], location_name="United States", language_code="en", limit=100)

Merge into one candidate list, deduplicate.

### Step 2: Classify intent
Call `mcp__dataforseo__dataforseo_labs_search_intent` for the merged list (chunk if >50).

Keep only:
- **informational** (good for topical authority + Thin Starter Pages)
- **commercial** (good for BoF / "X vs Y" / "best X" pages)

Drop "navigational" (brand searches) and "transactional" (typically converted by existing pages, not topical expansion).

### Step 3: Find what we already cover
Call `mcp__gsc__advanced_search_analytics`:
- dimensions=["query"]
- filter the candidate list via regex (limit to ~20 of the most interesting; if list bigger, sample by impressions)
- days=90
- This tells us which cluster keywords we're ALREADY ranking for (even Pos 50+)

### Step 4: Difficulty for unranked candidates
For candidates we DON'T already rank for, call `mcp__dataforseo__dataforseo_labs_bulk_keyword_difficulty`.

### Step 5: Three-bucket output

Sort candidates into:

**Bucket A — Push existing**: Already ranking Pos 6-30 for these. KD<40. Internal link push from authority pages (Section 17). Highest ROI. **Relevance gate (Sections 1 + 26.3):** only link where the anchor + surrounding paragraph match the target topic AND a user-bridge exists (source-topic searchers also plausibly search the target); descriptive 2-5-word anchor, placed mid-paragraph, never footer/nav — off-topic links carry ~0 weight even from a strong hub.

**Bucket B — Thin Starter Page candidates**: Not ranking yet. KD<25. Search volume >50/mo. Section 18 protocol: 200-400 word draft, publish, watch GSC for 2-4 weeks, expand only if traction.

**Bucket C — Skip / Park**: KD>50 (need more authority first), OR informational intent but already over-saturated SERP (AI Overview + Reddit + Wiki dominant).

## Output Format

Three markdown tables, one per Bucket, with Keyword, Position (where ranking), Impressions, Volume, KD, Intent.

Below: 1-paragraph cluster strategy summary. What's the topical story we'd tell with these new pages? What's the natural Hub URL we should create or already have?

## Cost
~$0.10 per cluster expansion (Labs related/ideas/intent/difficulty calls).
