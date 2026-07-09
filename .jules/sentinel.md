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
