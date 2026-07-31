import http.server
import socketserver
import threading
import time
import os
import sys
from playwright.sync_api import sync_playwright

PORT = 8000

class QuietSimpleHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        # Suppress logging server requests to stdout
        pass

def run_server():
    handler = QuietSimpleHTTPRequestHandler
    with socketserver.TCPServer(("", PORT), handler) as httpd:
        httpd.serve_forever()

def main():
    # Start local HTTP server in a daemon thread
    server_thread = threading.Thread(target=run_server, daemon=True)
    server_thread.start()

    # Wait for the server to spin up
    time.sleep(1)

    print("🛡️ Sentinel Verification: Starting Playwright check...")

    success = True
    console_errors = []

    with sync_playwright() as p:
        # Launch browser headless
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # Listen to console messages for any errors or CSP violations
        def handle_console(msg):
            if msg.type in ["error", "warning"]:
                print(f"[{msg.type.upper()}] {msg.text}")
                if "error" in msg.type:
                    console_errors.append(msg.text)
            else:
                print(f"[LOG] {msg.text}")

        page.on("console", handle_console)
        page.on("pageerror", lambda err: console_errors.append(err.message))

        # Navigate to index.html served over HTTP
        url = f"http://localhost:{PORT}/index.html"
        print(f"Navigating to {url}...")
        page.goto(url)

        # Check document display style (fail-closed clickjacking protection should reveal it as self === top)
        display_style = page.evaluate("getComputedStyle(document.documentElement).display")
        print(f"Document element display style: {display_style}")
        if display_style != "block":
            print("❌ Error: Document element display style is not 'block'. UI might be hidden!")
            success = False

        # Verify CSP meta tag content
        csp_content = page.locator("meta[http-equiv='Content-Security-Policy']").get_attribute("content")
        print(f"Found Content-Security-Policy: {csp_content}")
        if "trusted-types 'none'" not in csp_content:
            print("❌ Error: 'trusted-types 'none'' is missing from Content-Security-Policy!")
            success = False

        # Verify Permissions-Policy content
        permissions_content = page.locator("meta[http-equiv='Permissions-Policy']").get_attribute("content")
        print(f"Found Permissions-Policy: {permissions_content}")
        expected_policies = [
            "camera=()", "microphone=()", "geolocation=()", "display-capture=()",
            "accelerometer=()", "gyroscope=()", "magnetometer=()", "payment=()", "usb=()",
            "ambient-light-sensor=()", "autoplay=()", "battery=()", "document-domain=()",
            "encrypted-media=()", "execution-while-not-rendered=()", "execution-while-out-of-viewport=()",
            "fullscreen=()", "gamepad=()", "picture-in-picture=()", "screen-wake-lock=()",
            "web-share=()", "xr-spatial-tracking=()", "interest-cohort=()", "hid=()", "serial=()", "sync-xhr=()"
        ]
        for policy in expected_policies:
            if policy not in permissions_content:
                print(f"❌ Error: Missing expected policy '{policy}' in Permissions-Policy meta tag!")
                success = False

        # Let the page execute scripts and check for any console issues
        time.sleep(1)

        # Take a screenshot of the verified page
        screenshot_path = "verification_screenshot.png"
        page.screenshot(path=screenshot_path)
        print(f"Screenshot saved to {screenshot_path}")

        browser.close()

    if console_errors:
        print(f"❌ Error: Console errors occurred during page execution: {console_errors}")
        success = False

    if success:
        print("✅ Sentinel Verification: All security checks PASSED successfully!")
        sys.exit(0)
    else:
        print("❌ Sentinel Verification: Some security checks FAILED!")
        sys.exit(1)

if __name__ == "__main__":
    main()
