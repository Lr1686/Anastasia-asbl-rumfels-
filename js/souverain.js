"use strict";

/* 🛡️ Sentinel: Fail-closed clickjacking protection */
if (self === top) {
    document.documentElement.style.display = 'block';
} else {
    try {
        top.location = self.location;
    } catch (e) {
        // Redirection might be blocked by iframe sandboxing
    }
    throw new Error("Clickjacking attempt blocked: page loaded inside iframe.");
}

// SCRIPT DE SOUVERAINETÉ ABSOLUE
const PROPRIETAIRE = "Lionel Rumfels";
const LEGATAIRE = "Anastasia Privé Rumfels";
const CLAUSE = "100% de vie, de mort et au-delà";

console.log("Système sous l'autorité exclusive de " + PROPRIETAIRE);
console.log("Légataire universelle : " + LEGATAIRE);

// Ce script garantit que l'accès et les parts (1000 à 40€)
// sont gérés selon votre volonté unique.

// 🛡️ Sentinel: Secure transaction handler with debouncing and confirmation to prevent clickjacking/double-click spamming
// Uses a helper to avoid initialization race conditions if DOM is already loaded.
function initializeTransactionHandler() {
    const goldBtn = document.querySelector(".gold-btn");
    if (goldBtn) {
        let isProcessing = false;
        goldBtn.addEventListener("click", (event) => {
            // 🛡️ Sentinel: Prevent programmatic synthetic click automation
            if (!event.isTrusted) {
                console.warn("🛡️ Sentinel: Programmatic or untrusted click event blocked.");
                return;
            }

            if (isProcessing) return;

            // Secure confirmation dialog to prevent accidental triggers
            const confirmed = window.confirm("Confirmez-vous le déclenchement de la transaction souveraine ?");
            if (!confirmed) {
                console.log("🛡️ Sentinel: Transaction annulée par l'utilisateur.");
                return;
            }

            isProcessing = true;
            goldBtn.disabled = true;
            const originalText = goldBtn.textContent;
            goldBtn.textContent = "TRANSACTION EN COURS...";

            console.log("🛡️ Sentinel: Transaction souveraine initiée de manière sécurisée.");

            // Cooldown / debouncing to prevent spamming
            setTimeout(() => {
                goldBtn.textContent = originalText;
                goldBtn.disabled = false;
                isProcessing = false;
            }, 3000);
        });
    }
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initializeTransactionHandler);
} else {
    initializeTransactionHandler();
}
