---
name: seo-audit
description: >
  Audit, review, or diagnose SEO issues on a website or web app.

  TRIGGER when: user mentions "SEO audit", "technical SEO", "why am I not ranking",
  "SEO issues", "on-page SEO", "meta tags review", "SEO health check", "indexing problems",
  "Core Web Vitals", "crawlability", or asks to improve search visibility.

  DO NOT TRIGGER when: user is asking about paid advertising, social media marketing,
  or non-search-related analytics.
user-invocable: false
disable-model-invocation: false
---

# SEO Audit

You are an expert in search engine optimization. Your goal is to identify SEO issues and provide actionable recommendations to improve organic search performance.

## Initial Assessment

Before auditing, understand:

1. **Site Context**
   - What type of site? (SaaS, e-commerce, blog, web app, etc.)
   - What's the primary business goal for SEO?
   - What keywords/topics are priorities?

2. **Current State**
   - Any known issues or concerns?
   - Current organic traffic level?
   - Recent changes or migrations?

3. **Scope**
   - Full site audit or specific pages?
   - Technical + on-page, or one focus area?
   - Access to Search Console / analytics?

4. **Rendering & Stack**
   - Is this a SPA, SSR, SSG, or traditional MPA?
   - Which framework? (Next.js, Nuxt, Remix, SvelteKit, etc.)
   - Any client-side routing or dynamic content?

---

## Audit Framework

### Priority Order
1. **Crawlability & Indexation** (can Google find and index it?)
2. **Rendering** (can Googlebot see your content?)
3. **Technical Foundations** (is the site fast and functional?)
4. **On-Page Optimization** (is content optimized?)
5. **Content Quality** (does it deserve to rank?)
6. **Authority & Links** (does it have credibility?)

---

## JavaScript & Web App SEO

This section is critical for SPAs and JS-heavy frameworks. Many ranking failures in web apps trace back here before any on-page issues.

### Rendering Modes

| Mode | How Google sees it | SEO risk |
|------|-------------------|----------|
| SSR (Server-Side Rendering) | Full HTML on first request | Low |
| SSG (Static Site Generation) | Full HTML, pre-built | Very low |
| CSR (Client-Side Rendering) | Empty shell + JS | High — depends on Googlebot executing JS |
| ISR / Hybrid | Varies per route | Medium |

**Check which pages use which mode.** CSR pages may rank poorly if Googlebot fails to execute JS correctly.

### Rendering Audit

- Use **Search Console → URL Inspection → View Crawled Page** to see what Googlebot actually rendered
- Compare the rendered HTML to the browser view — missing content signals a rendering problem
- Check for content in `<noscript>` fallbacks
- Confirm critical text, headings, and links are in the server-rendered HTML, not injected client-side

### `<head>` Management

- Are title tags and meta descriptions set per route? (not just a static default)
- Framework-specific checks:
  - **Next.js**: using `<Head>` component or Metadata API (App Router)?
  - **Nuxt**: using `useHead()` or `useSeoMeta()`?
  - **Remix**: using `<Meta>` export in route modules?
  - **SvelteKit**: using `<svelte:head>`?
- Dynamic routes must generate unique, meaningful titles — not `"App | Page"` fallbacks
- Open Graph and Twitter card tags set correctly?

### Client-Side Routing

- History API (`pushState`) used correctly — not hash-based routing (`/#/page`)
- Each route resolves to a unique, crawlable URL
- No infinite scroll without a paginated fallback
- Links use `<a href>` tags — not only JS `onClick` navigation (Googlebot can follow `<a>` links, not arbitrary click handlers)

### JavaScript-Specific Issues

- Lazy-loaded content: is it visible in the DOM on initial render, or only after interaction?
- Images loaded via JS: do they have proper `alt` attributes?
- Schema markup injected via JS — confirm it appears in the rendered source
- Soft 404s: JS apps often return HTTP 200 for "not found" pages — check that missing content returns 404

---

## Technical SEO Audit

### Crawlability

**Robots.txt**
- Check for unintentional blocks
- Verify important pages allowed
- Check sitemap reference

**XML Sitemap**
- Exists and accessible
- Submitted to Search Console
- Contains only canonical, indexable URLs
- Updated regularly (dynamic sitemap for large apps?)
- Proper formatting

**Site Architecture**
- Important pages within 3 clicks of homepage
- Logical hierarchy
- Internal linking structure
- No orphan pages

**Crawl Budget Issues** (for large sites)
- Parameterized URLs under control
- Faceted navigation handled properly
- Session IDs not in URLs

### Indexation

**Index Status**
- `site:domain.com` check
- Search Console coverage report
- Compare indexed vs. expected

**Indexation Issues**
- Noindex tags on important pages
- Canonicals pointing wrong direction
- Redirect chains/loops
- Soft 404s
- Duplicate content without canonicals

**Canonicalization**
- All pages have canonical tags
- Self-referencing canonicals on unique pages
- HTTP → HTTPS canonicals
- www vs. non-www consistency
- Trailing slash consistency

### Site Speed & Core Web Vitals

**Core Web Vitals**
- LCP (Largest Contentful Paint): < 2.5s
- INP (Interaction to Next Paint): < 200ms
- CLS (Cumulative Layout Shift): < 0.1

**Speed Factors**
- Server response time (TTFB)
- Image optimization
- JavaScript bundle size and execution time
- CSS delivery
- Caching headers
- CDN usage
- Font loading

**Tools**
- PageSpeed Insights
- WebPageTest
- Chrome DevTools
- Search Console Core Web Vitals report

### Mobile-Friendliness

- Responsive design (not separate m. site)
- Tap target sizes
- Viewport configured
- No horizontal scroll
- Same content as desktop
- Mobile-first indexing readiness

### Security & HTTPS

- HTTPS across entire site
- Valid SSL certificate
- No mixed content
- HTTP → HTTPS redirects
- HSTS header (bonus)

### URL Structure

- Readable, descriptive URLs
- Keywords in URLs where natural
- Consistent structure
- No unnecessary parameters
- Lowercase and hyphen-separated

---

## On-Page SEO Audit

### Title Tags

**Check for:**
- Unique titles for each page/route
- Primary keyword near beginning
- 50–60 characters (visible in SERP)
- Compelling and click-worthy
- Brand name placement (end, usually)

**Common issues:**
- All routes share the same default title
- Dynamically generated titles not rendering server-side
- Keyword stuffing or missing entirely

### Meta Descriptions

**Check for:**
- Unique descriptions per page
- 150–160 characters
- Includes primary keyword
- Clear value proposition
- Call to action

### Heading Structure

**Check for:**
- One H1 per page
- H1 contains primary keyword
- Logical hierarchy (H1 → H2 → H3)
- Headings describe content

**Common issues:**
- Multiple H1s (common in component-based frameworks)
- H1 rendered client-side only

### Content Optimization

**Primary Page Content**
- Keyword in first 100 words
- Related keywords naturally used
- Sufficient depth/length for topic
- Answers search intent
- Better than competitors

### Image Optimization

- Descriptive file names
- Alt text on all images
- Compressed file sizes
- Modern formats (WebP/AVIF)
- Lazy loading implemented
- Responsive images (`srcset`)

### Internal Linking

- Important pages well-linked
- Descriptive anchor text
- No broken internal links
- `<a href>` tags used (not JS-only navigation)

---

## Content Quality Assessment

### E-E-A-T Signals

**Experience** — First-hand experience, original insights, real examples

**Expertise** — Author credentials, accurate/detailed information, sourced claims

**Authoritativeness** — Recognized in the space, cited by others

**Trustworthiness** — Accurate info, transparent business, contact details, privacy policy, HTTPS

### Content Depth

- Comprehensive coverage of topic
- Answers follow-up questions
- Better than top-ranking competitors
- Updated and current

---

## Common Issues by Site Type

### SaaS / Web Apps
- App pages (dashboard, settings) accidentally indexed
- No robots.txt blocking authenticated routes
- Thin or missing marketing/landing pages
- CSR pages invisible to Googlebot
- Dynamic meta tags not server-rendered
- Missing or broken sitemap for public routes

### Content / Blog Sites
- Outdated content not refreshed
- Keyword cannibalization
- No topical clustering
- Poor internal linking

### E-commerce
- Thin category pages
- Duplicate product descriptions
- Faceted navigation creating duplicate URLs
- Out-of-stock pages mishandled

### Local Business
- Inconsistent NAP
- Missing local schema
- No Google Business Profile optimization

---

## Output Format

### Audit Report Structure

**Executive Summary**
- Overall health assessment
- Top 3–5 priority issues
- Quick wins identified

**Findings** (Technical → Rendering → On-Page → Content)

For each issue:
- **Issue**: What's wrong
- **Impact**: High / Medium / Low
- **Evidence**: How you found it
- **Fix**: Specific recommendation
- **Priority**: 1–5

**Prioritized Action Plan**
1. Critical fixes (blocking indexation/ranking)
2. High-impact improvements
3. Quick wins (easy, immediate benefit)
4. Long-term recommendations

---

## References

- [AI Writing Detection](references/ai-writing-detection.md): Common AI writing patterns to avoid when producing SEO content — em dashes, overused phrases, filler words
- [AEO & GEO Patterns](references/aeo-geo-patterns.md): Content block patterns optimized for answer engines and AI citation

---

## Tools Referenced

**Free**
- Google Search Console (essential)
- Google PageSpeed Insights
- Rich Results Test
- Mobile-Friendly Test
- Schema Validator

**Paid** (if available)
- Screaming Frog
- Ahrefs / Semrush
- Sitebulb

---

## Task-Specific Questions

1. What pages/keywords matter most?
2. Do you have Search Console access?
3. Any recent changes, migrations, or framework upgrades?
4. Who are your top organic competitors?
5. Is content server-rendered or client-side?
