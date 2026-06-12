---
description: Find pages worth Re-Evaluation Republish (Pos 8-25 + KD<30 + Cluster grew since publish)
argument-hint: "<domain or sc-domain:domain>"
---

You are running a Re-Evaluation Hack audit for: **$ARGUMENTS**

Background (Sections 19, 26.3 of the knowledge base):
- NavBoost uses a 13-month rolling click-data window (Pandu Nayak sworn DOJ testimony)
- Pages published when cluster was small got evaluated with old authority — never re-evaluated
- Republish under new URL + 301 from old = Google evaluates with current authority
- Target: pages at Pos 8-25 with KD<30 where you've built more cluster authority since publish

## Execute

### Step 1: Identify candidate range (Pos 8-25)
Call `mcp__gsc__advanced_search_analytics`:
- dimensions=["query", "page"]
- order_by: impressions descending
- days=90 (longer window for trend confidence)
- row_limit=100

Filter results to Pos 8-25 inclusive in your post-processing.

### Step 2: Group by page URL
Multiple queries may point to the same page. Aggregate per page: sum impressions, list of queries, weighted-avg position.

Keep only pages where total impressions across all queries >= 200/mo (otherwise re-eval ROI too low).

### Step 3: Difficulty check on the highest-volume query per page
For each candidate page's top query, call `mcp__dataforseo__dataforseo_labs_bulk_keyword_difficulty`.

Filter: KD < 30.

### Step 4: Discovery date check
For each surviving candidate, call `mcp__gsc__inspect_url` with the page URL.
- Extract discovered_date (when Google first found the URL)
- If discovered_date is < 6 months ago: skip (not enough time for cluster authority growth)
- If discovered_date is > 6 months ago: strong republish candidate

### Step 5: Output republish plan

For each surviving page give: current URL, suggested new URL (year-bump or topic-clarification), primary keyword, current position, total monthly impressions, KD, age, estimated lift (based on position curve, e.g. Pos 15 to Pos 5 = 5-8x traffic).

## Output Format

Markdown table sorted by est. lift descending.

Below: 301-redirect rule examples (for nginx/Cloudflare) and a republish checklist:
1. Create new URL with improved content (year-bump, expanded sections, modernized tone)
2. Set 301 from old URL to new URL
3. Update internal links to point at new URL
4. Wait 4-8 weeks for NavBoost re-evaluation
5. Track in GSC

## Cost
~$0.05 per audit.

## Important warnings
- DO NOT republish pages at Pos 1-5 (already winning, don't break it)
- DO NOT republish without 301 (loses external backlinks)
- DO NOT republish without content improvement (Google detects stale rewrites)
