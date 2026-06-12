---
description: Live-extract a code-verified product fact-sheet from a project's app + website repos. Pulled FRESH from source every run (no cache) — the truth layer that lets SEO briefs sell the tool without inventing features.
argument-hint: [app-folder] [website-folder] — optional; auto-detects siblings
---

You are extracting a **code-verified product fact-sheet** for: **$ARGUMENTS** (or the current project if no args).

Purpose: pull the REAL facts about the product — exact pricing, supported platforms, actual features, honest limitations — straight from the **source code, LIVE, every single time**. No hand-maintained manifest (those go stale the moment the app changes). Every fact carries `file:line` provenance so a brief can sell the tool truthfully and auditably.

**Hard rule: always live, never cached.** Re-read the source on every run. Code is the source of truth — if any doc/`FEATURE-MANIFEST.md` disagrees with the code, **the code wins** (treat the doc as a hint only).

## Step 1: Resolve the source repos (auto, zero-config)
- The current working directory is one source.
- Derive the sibling by naming convention: if the cwd ends in `-website`, the app repo is the same name **without** `-website` (e.g. `acme-website` → `../acme`); otherwise the site is `<name>-website`. Check both sibling dirs exist.
- If folder args are passed, use those instead of auto-detect.
- Confirm each path is a real repo (`package.json` or `.git`). State which repos you're reading. If only one is found, proceed with it and say so. If none reachable, STOP and tell the user.

## Step 2: Extract facts LIVE — targeted reads, every run
Use Glob/Grep to LOCATE the high-signal files, then Read them. Do NOT dump the whole codebase — target these per category (read from BOTH the app repo for capability truth and the website repo for published positioning):

**A · Identity & positioning** — `README.md`, app homepage (`app/page.tsx` / marketing route), hero + `<meta>` copy, any `/vs/<competitor>` pages on the site.
**B · Pricing** — pricing route (`**/pricing*`), price constants / Stripe config (`grep -i "price|lifetime|/mo|/year|\$[0-9]|plan|tier"`). Report exact numbers + model (one-time vs subscription). Never read secret values — field names only.
**C · Supported platforms / integrations** — `package.json` dependencies (e.g. DB drivers: `pg`, `mysql2`, `better-sqlite3`, `mongodb`, …) **cross-checked** with the connection-type enum/switch in the app (`grep` the driver names / a type union / connection manager). List only verified types.
**D · Features** — feature components (`components/**`), routes (`app/**/page.tsx`), API endpoints (`app/api/**/route.ts`), feature flags. Derive the capability list from what actually exists in code.
**E · Honest limitations (CRITICAL)** — `grep -ri "not implemented|coming soon|TODO|roadmap|@deprecated"` + stubs that `return []` / `return null` / `throw .*not`. These become the ❌-NOT-implemented list. Roadmap items are "planned", never "current".
**F · Security / tech claims** — only code-evidenced (encryption libs, auth middleware, Docker, framework versions from `package.json`).
**G · Per-competitor differentiators** — derive from real architecture (web app vs desktop, pricing model, self-hosted/Docker) + reuse claims already published on the site's `/vs/` pages.

## Step 3: Output the fact-sheet
Structured markdown. **Every fact cites its source as `repo/path:line`** (or `repo/path` for whole-file signals). Sections:

```
# Product Facts — <product> (live-extracted <date>, no cache)
Sources read: <app repo> @ <git short-hash> · <website repo> @ <git short-hash>

## Identity / positioning        (tagline, value prop, category)
## Pricing                       (exact $, model)            — src
## Supported platforms           (verified list)             — src
## Features (✅ verified)         (capability → what it does) — src each
## NOT implemented / roadmap (❌) (do NOT claim as current)  — src each
## Security / tech                (only code-evidenced)       — src
## Per-competitor differentiators (web vs desktop, price, self-hosted…)
## Audience pain points           (from README/homepage copy)
## ⚠️ Low-confidence / inferred   (facts not 100% certain from code — flag for human check)
```

## Rules
- **LIVE every run, no cache.**
- **Code wins.** A `FEATURE-MANIFEST.md` or marketing page is a hint; verify against code, prefer code on conflict.
- **Cite `file:line` for every claim.** No citation → not a fact → don't state it.
- **Limitations are features** — surface them honestly (an honest "covers the 6 most common platforms" beats a false "supports everything").
- **Never invent.** If it's not in the code, it doesn't go in the sheet. Flag anything inferred under Low-confidence.

## Cost
~$0 external API (local Glob/Grep/Read only). Token cost scales with repo size — targeted reads (not full-codebase dumps) keep each live pull bounded.
