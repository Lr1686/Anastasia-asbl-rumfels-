import os
import sys
import http.server
import socketserver
import threading
import time
from playwright.sync_api import sync_playwright

PORT = 8087

class SilentHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        pass # suppress request logs to keep stdout clean

def run_server():
    handler = SilentHTTPRequestHandler
    with socketserver.TCPServer(("", PORT), handler) as httpd:
        print(f"🛡️ Sentinel: Test server running on port {PORT}")
        httpd.serve_forever()

def main():
    # Start server in daemon thread
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()

    # Wait for server to boot up
    time.sleep(1)

    success = False
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()

            url = f"http://localhost:{PORT}/index.html"
            print(f"🛡️ Sentinel: Opening {url}")
            page.goto(url)

            # 1. Assert CSP Meta Tag Content
            csp_element = page.locator('meta[http-equiv="Content-Security-Policy"]')
            csp_content = csp_element.get_attribute("content")
            print(f"🛡️ Sentinel: Found CSP: {csp_content}")

            expected_csp = "default-src 'none'; style-src 'self'; script-src 'self'; connect-src 'none'; img-src 'none'; font-src 'none'; frame-src 'none'; media-src 'none'; manifest-src 'none'; worker-src 'none'; object-src 'none'; base-uri 'self'; form-action 'none'; upgrade-insecure-requests; require-trusted-types-for 'script'; trusted-types 'none';"
            assert csp_content == expected_csp, f"CSP mismatch!\nExpected: {expected_csp}\nGot: {csp_content}"
            print("✅ CSP validation passed successfully!")

            # 2. Assert Permissions-Policy Meta Tag Content
            policy_element = page.locator('meta[http-equiv="Permissions-Policy"]')
            policy_content = policy_element.get_attribute("content")
            print(f"🛡️ Sentinel: Found Permissions-Policy: {policy_content}")

            expected_policy = "camera=(), microphone=(), geolocation=(), display-capture=(), accelerometer=(), gyroscope=(), magnetometer=(), payment=(), usb=(), ambient-light-sensor=(), autoplay=(), battery=(), document-domain=(), encrypted-media=(), execution-while-not-rendered=(), execution-while-out-of-viewport=(), fullscreen=(), gamepad=(), picture-in-picture=(), screen-wake-lock=(), web-share=(), xr-spatial-tracking=(), interest-cohort=(), hid=(), serial=(), sync-xhr=()"
            assert policy_content == expected_policy, f"Permissions-Policy mismatch!\nExpected: {expected_policy}\nGot: {policy_content}"
            print("✅ Permissions-Policy validation passed successfully!")

            # 3. Assert Clickjacking display style modifications
            # The clickjacking script should change style.display of html to 'block' when not framed
            html_display = page.evaluate("window.getComputedStyle(document.documentElement).display")
            print(f"🛡️ Sentinel: Found html computed display style: {html_display}")
            assert html_display == "block", f"HTML element display style is not 'block', got: {html_display}"
            print("✅ Fail-closed clickjacking protection validation passed successfully!")

            # 4. Verify no console errors or integrity blocks
            # (If the integrity hashes were invalid, the page would remain blank / hidden)
            container_visible = page.locator(".master-container").is_visible()
            assert container_visible, "Master container is not visible. Assets or scripts may have failed to load."
            print("✅ Main UI container is visible and active!")

            browser.close()
            success = True
    except Exception as e:
        print(f"❌ Security Verification Failed: {e}", file=sys.stderr)
        sys.exit(1)

    if success:
        print("🎉 All Sentinel security checks passed!")
        sys.exit(0)

if __name__ == "__main__":
    main()
