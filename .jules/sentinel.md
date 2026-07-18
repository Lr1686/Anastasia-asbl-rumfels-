# Sentinel Journal - Anastasia Privé Rumfels project

## 2026-07-06 - Initial Security Enhancement
**Vulnerability:** Weak security baseline.
**Learning:** The project is a collection of personal files and a static landing page. It lacked a .gitignore to prevent accidental secret commits and basic security headers in the HTML to protect users.
**Prevention:** Establish a minimal security baseline by adding a .gitignore for common sensitive patterns and implementing defense-in-depth security meta tags in the entry HTML file.

## 2026-07-07 - Security Hardening & Secret Prevention
**Vulnerability:** Insufficient frontend hardening and potential secret leakage.
**Learning:** Static sites without backend control over headers need client-side defense-in-depth. Basic CSP lacked restrictive directives, and `.gitignore` missed common sensitive system files and key formats.
**Prevention:** Use restrictive CSP meta tags (`object-src 'none'`, `form-action 'none'`), implement frame-busting scripts for clickjacking protection, and maintain a comprehensive `.gitignore` for shell history and private keys.

## 2026-07-09 - CSP Hardening and Asset Externalization
**Vulnerability:** 'unsafe-inline' in Content Security Policy.
**Learning:** Even with a CSP, allowing 'unsafe-inline' for scripts and styles significantly weakens protection against XSS. Static sites should externalize assets to enable a strict CSP without 'unsafe-inline'.
**Prevention:** Always externalize CSS and JS to separate files and use a restrictive CSP that forbids 'unsafe-inline'. Added 'upgrade-insecure-requests' as an additional layer of security.

## 2026-07-10 - Integrity Verification and CSP Hardening
**Vulnerability:** Risk of unauthorized asset modification and overly permissive default CSP.
**Learning:** Static sites that claim to be "unattackable" should employ Subresource Integrity (SRI) to guarantee that only verified assets are executed. Furthermore, a `default-src 'self'` policy is still more permissive than necessary; `default-src 'none'` is the true secure baseline for static pages with known dependencies.
**Prevention:** Implement SRI hashes for all external scripts and styles. Harden the CSP by setting `default-src 'none'` and explicitly allowing only trusted local assets. Use `Permissions-Policy` to disable unused browser features (camera, mic, etc.) by default.

## 2026-07-12 - Fail-Closed Clickjacking Protection and Trusted Types
**Vulnerability:** Standard frame-busting scripts can be bypassed; lack of DOM XSS defense-in-depth.
**Learning:** Traditional clickjacking protection (like `if (self !== top) top.location = self.location`) can sometimes be mitigated by a framing page using the `sandbox` attribute. A "fail-closed" approach where the UI is hidden by default via CSS and only revealed via JS after a successful `self === top` check is much more robust. Additionally, adding `require-trusted-types-for 'script'` to the CSP helps prevent DOM-based XSS by requiring developers to use Trusted Types policies instead of dangerous sinks.
**Prevention:** Use `html { display: none; }` in CSS and `if (self === top) document.documentElement.style.display = 'block';` in JS. Always include `require-trusted-types-for 'script'` in CSP for modern browser protection.

## 2026-07-16 - CSP Hardening and JS Strict Mode
**Vulnerability:** Potential for DOM XSS via Trusted Types and common JS pitfalls.
**Learning:** Adding `trusted-types 'none'` to CSP (when used with `require-trusted-types-for 'script'`) completely blocks the creation of any Trusted Types policies, providing the highest level of defense-in-depth against DOM XSS for applications that don't need them. Enabling `"use strict";` in JS prevents accidental global variables and other insecure practices.
**Prevention:** Use `trusted-types 'none'` in CSP for static sites with no dynamic policy needs. Always enforce `"use strict";` in core JS assets.
## 2026-07-14 - Attack Surface Reduction and Header Hardening
**Vulnerability:** Unused legacy assets and missing modern security headers (Trusted Types 'none', expanded Permissions-Policy).
**Learning:** Maintaining unused code increases the attack surface unnecessarily. Modern headers like `trusted-types 'none'` and comprehensive `Permissions-Policy` provide additional layers of defense-in-depth even for static sites.
**Prevention:** Regularly audit for and remove unused assets. Implement restrictive modern security headers by default, including `trusted-types 'none'` to block DOM-based XSS injection sinks.

## 2026-07-18 - Strict CSP Style compliance and Inline Styles Elimination
**Vulnerability:** Strict Content Security Policy style-src 'self' blocked by inline styles.
**Learning:** Defining a strict Content Security Policy with `style-src 'self'` prevents any inline style attributes on HTML elements from executing. In this codebase, the active sale status box was hardcoded with inline styles, triggering browser security blocks. To prevent the temptation of relaxing the CSP to `'unsafe-inline'` (which exposes the app to dangerous CSS injection and DOM data exfiltration), inline styles must be externalized to pre-defined classes.
**Prevention:** Migrate all remaining inline style attributes to existing or new CSS rules within the secure, integrity-validated external stylesheet.
