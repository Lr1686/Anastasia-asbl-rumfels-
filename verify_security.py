import subprocess
import time
import re
import pytest
from playwright.sync_api import sync_playwright, expect

@pytest.fixture(scope="module", autouse=True)
def start_server():
    # Start python HTTP server in the root directory
    process = subprocess.Popen(["python3", "-m", "http.server", "8000"])
    time.sleep(1.5)  # Let server spin up
    yield
    process.terminate()
    process.wait()

def test_security_headers():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto("http://localhost:8000/index.html")

        # 1. Assert Content-Security-Policy (CSP) meta tag exists and is hardened
        csp_element = page.locator("meta[http-equiv='Content-Security-Policy']")
        expect(csp_element).to_be_attached()
        csp_content = csp_element.get_attribute("content")

        assert "default-src 'none'" in csp_content, "CSP should restrict default-src to 'none'"
        assert "require-trusted-types-for 'script'" in csp_content, "CSP should require trusted types for scripts"
        assert "trusted-types 'none'" in csp_content, "CSP should disallow custom trusted types policies"
        assert "style-src 'self'" in csp_content, "CSP should restrict styles to 'self'"
        assert "script-src 'self'" in csp_content, "CSP should restrict scripts to 'self'"

        # 2. Assert Permissions-Policy meta tag exists and disables unused browser features
        permissions_element = page.locator("meta[http-equiv='Permissions-Policy']")
        expect(permissions_element).to_be_attached()
        permissions_content = permissions_element.get_attribute("content")

        assert "camera=()" in permissions_content
        assert "microphone=()" in permissions_content
        assert "geolocation=()" in permissions_content
        assert "ambient-light-sensor=()" in permissions_content
        assert "autoplay=()" in permissions_content

        # 3. Assert Privacy/Scraping Robots meta tag exists and is restrictive
        robots_element = page.locator("meta[name='robots']")
        expect(robots_element).to_be_attached()
        robots_content = robots_element.get_attribute("content")
        assert "noindex" in robots_content
        assert "nofollow" in robots_content
        assert "noarchive" in robots_content

        # 4. Assert client-side fail-closed clickjacking protection is functional
        # The page is visible under self === top
        expect(page.locator("html")).to_have_css("display", "block")

        browser.close()
