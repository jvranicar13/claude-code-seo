---
description: Detect and resolve keyword cannibalization (multiple pages competing for same query)
argument-hint: "<domain or sc-domain:domain>"
---

You are running a Cannibalization audit for: **$ARGUMENTS**

Background (Sections 1, 5, 26.6 of the knowledge base):
- Each page accumulates its own authority — multiple pages claiming the same keyword block each other
- Embedding-similarity >=0.85 between competing pages = real duplicate, not just keyword overlap
- Resolution priorities: 301 merge > canonical > noindex > content differentiation

## Execute

### Step 1: Pull all cannibalization conflicts
Call `mcp__gsc__cannibalization_check`:
- days=28
- min_impressions=50

If no results: report cleanly that no cannibalization exists with current thresholds. Don't manufacture findings.

### Step 2: Categorize each conflict

For each conflict, identify the **Master Page** (best candidate to consolidate to):
- Highest clicks
- Best position
- Best title-query match
- Most internal links pointing to it (if data available via GSC advanced_search_analytics with page dimension)

The other competing pages are **Loser Pages**.

### Step 3: Pattern-detect the conflict type

Common patterns to detect:
- **Anchor-fragments** (e.g. `/blog/x` vs `/blog/x#section`): Both rank for same query. Page = same. Solution: header IDs not crawled as separate pages — server-side rewrite h2 IDs or use data-nosnippet.
- **Filter-parameters** (e.g. `/?city=austin` vs `/`): Server-side noindex on parameter URLs OR convert to canonical routes (`/jobs/austin`).
- **Topical near-duplicates** (e.g. `/blog/best-pgadmin-alternatives` vs `/blog/best-postgresql-client`): Real competition between articles. Resolve by intent differentiation or 301 to master.
- **Brand variants** (e.g. all subpages rank for own brand): Expected behavior, not a problem. Skip.
- **SERP rotation (NOT cannibalization)**: pages alternating in the SERP over time, one visible at a time, combined visibility stable. Normal Google behavior — NO action needed. Only treat as true cannibalization when both pages are suppressed simultaneously (combined impressions sag while neither holds the position either page reached alone). Check the 28-90d trend before recommending any 301 — misclassifying rotation causes unnecessary redirects.

### Step 4: Action plan per conflict

For each non-trivial conflict, output the master URL, loser URLs, pattern type, recommended action (301 / noindex / differentiation / accept), and estimated impact (high/medium/low).

## Output Format

Markdown table for the conflicts, sorted by combined impressions descending:

| Query | Combined Imp. | Master | # Losers | Pattern | Action |
|---|---|---|---|---|---|

Below: prioritized fix list (top 3 by impact).

Be specific: if pattern is "anchor-fragment", give the exact CSS/HTML fix. If "filter-param", show the noindex meta-tag syntax.

## Cost
~$0 (GSC API is free).
