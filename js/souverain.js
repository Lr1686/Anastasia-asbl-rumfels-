"use strict";

/* 🛡️ Sentinel: Fail-closed clickjacking protection */
if (self === top) {
    document.documentElement.style.display = 'block';
} else {
    try {
        top.location = self.location;
    } catch (e) {
        // Prevent framing even if top navigation is blocked by sandboxing
        console.error("Framing detected and blocked.");
    }
}

// SCRIPT DE SOUVERAINETÉ ABSOLUE
const PROPRIETAIRE = "Lionel Rumfels";
const LEGATAIRE = "Anastasia Privé Rumfels";
const CLAUSE = "100% de vie, de mort et au-delà";

console.log("Système sous l'autorité exclusive de " + PROPRIETAIRE);
console.log("Légataire universelle : " + LEGATAIRE);

// Ce script garantit que l'accès et les parts (1000 à 40€)
// sont gérés selon votre volonté unique.
