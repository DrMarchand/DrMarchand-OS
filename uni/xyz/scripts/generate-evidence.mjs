import { mkdir, readFile, writeFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

import {
  LEGAL_AUTHORITY,
  Lifecycle,
  OPERATING_DBA,
  classifyExpectedObserved,
  classifyPhase,
  digest,
  lionheartGate,
  observe,
  receipt,
  roundTripAdapter,
  semanticDelta,
  transitionLifecycle
} from "../src/uni_xyz.mjs";

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const evidenceDir = join(root, "evidence");
await mkdir(evidenceDir, { recursive: true });

const sourcePaths = [
  "UNI.XYZ_PROPOSED_CANON.md",
  "PROMOTION_READINESS.md",
  "schema/uni_xyz.schema.json",
  "src/uni_xyz.mjs",
  "VALIDATION.md",
  "GITHUB_DRIFT.md",
  "identifier_manifest.json"
];
const sourceBundle = {};
for (const path of sourcePaths) {
  sourceBundle[path] = await readFile(join(root, path), "utf8");
}
const artifactSha256 = digest(sourceBundle);

const abMatrix = [];
for (const alphaChanged of [false, true]) {
  for (const betaChanged of [false, true]) {
    for (const different of [false, true]) {
      for (const connected of [false, true]) {
        const observed = observe({
          alphaBefore: { value: 0 },
          alphaAfter: { value: alphaChanged ? 1 : 0 },
          betaBefore: { value: 0 },
          betaAfter: { value: betaChanged ? 1 : 0 },
          different,
          connected,
          expectedChange: alphaChanged || betaChanged
        });
        abMatrix.push({
          id: `AB-${String(abMatrix.length + 1).padStart(2, "0")}`,
          expected: { alpha_changed: alphaChanged, beta_changed: betaChanged, different, connected },
          observed,
          pass:
            observed.alpha_changed === alphaChanged &&
            observed.beta_changed === betaChanged &&
            observed.different === different &&
            observed.connected === connected
        });
      }
    }
  }
}

const expectedObserved = [
  [true, true, "CONFIRMED_CAPABILITY_CANDIDATE"],
  [true, false, "FAILURE_OR_RESISTANCE"],
  [false, true, "SIDE_EFFECT_OR_DISCOVERY"],
  [false, false, "STABILITY_OR_INERT"]
].map(([expected, observed, classification], index) => ({
  id: `EO-${index + 1}`,
  expected_change: expected,
  observed_change: observed,
  expected_classification: classification,
  observed_classification: classifyExpectedObserved(expected, observed),
  pass: classifyExpectedObserved(expected, observed) === classification
}));

const phaseCases = {
  PARTICLE: { freedom: 0.2, relationship_strength: 0.1, energy: 0.2, pressure: 0.1, constraints: 0.1, geometry: 0.1, tolerance: 0.8 },
  GAS: { freedom: 0.9, relationship_strength: 0.2, energy: 0.8, pressure: 0.1, constraints: 0.2, geometry: 0.2, tolerance: 0.8 },
  LIQUID: { freedom: 0.6, relationship_strength: 0.6, energy: 0.5, pressure: 0.5, constraints: 0.5, geometry: 0.5, tolerance: 0.5 },
  SOLID: { freedom: 0.2, relationship_strength: 0.9, energy: 0.3, pressure: 0.8, constraints: 0.9, geometry: 0.9, tolerance: 0.1 }
};
const phases = Object.entries(phaseCases).map(([expected, measurements]) => {
  const observed = classifyPhase(measurements);
  return { expected, observed, pass: observed.classification === expected };
});

const gateNames = ["identity", "canon", "reflection", "drift", "gate"];
const negativeGates = gateNames.map((failed) => {
  const checks = Object.fromEntries(gateNames.map((name) => [name, name !== failed]));
  const observed = lionheartGate(checks);
  return { failed_check: failed, observed, pass: !observed.passed && observed.failed.length === 1 };
});

const semanticObject = {
  object_id: "UNI.XYZ:evidence",
  authority: { legal_authority: LEGAL_AUTHORITY, operating_dba: OPERATING_DBA },
  permitted_commands: ["VALIDATED_COMMAND"],
  evidence_requirements: ["EFFECT_RECEIPT"],
  semantic_behavior: { mode: "GOVERNED" }
};
const adapters = ["PHOENIX_SWIFTUI", "CHROMEOS_BOOTSTRAP", "WINDOWS", "ANDROID"].map((platform) => {
  const roundTrip = roundTripAdapter(platform, semanticObject, { theme: platform });
  const delta = semanticDelta(semanticObject, roundTrip.object);
  return { platform, semantic_delta: delta, pass: !delta.changed, receipt: roundTrip.receipt };
});

const externalReadbacks = [
  { system: "GOOGLE_DRIVE", status: "PASS", observation: "Hierarchy and proposal package resolved." },
  { system: "GITHUB", status: "VALIDATION", observation: "Admin/write authority confirmed; validation branch publication pending." },
  { system: "ONEDRIVE", status: "VALIDATION", observation: "Business drive resolved; package upload/readback pending." },
  { system: "ASANA", status: "BLOCKED", observation: "Private promotion task returned Not Authorized for the connected identity." },
  { system: "HUBSPOT", status: "BLOCKED", observation: "Intended and connected portals do not match; reauthorization is required." },
  { system: "ICLOUD", status: "BLOCKED", observation: "No connector or mounted target is available." },
  { system: "PHOENIX_SWIFT_TOOLCHAIN", status: "BLOCKED", observation: "Swift toolchain is unavailable; source boundary exists but is not compiled." },
  { system: "ANDROID_KOTLIN_TOOLCHAIN", status: "BLOCKED", observation: "Kotlin toolchain is unavailable; source boundary exists but is not compiled." },
  { system: "WINDOWS_DOTNET_TOOLCHAIN", status: "BLOCKED", observation: ".NET toolchain is unavailable; source boundary exists but is not compiled." }
];

const validationGate = lionheartGate({
  identity: true,
  canon: true,
  reflection: true,
  drift: false,
  gate: false
});
const validationTransition = transitionLifecycle({
  current: Lifecycle.PROPOSED,
  target: Lifecycle.VALIDATION,
  gate: validationGate
});
const authorityReceipt = {
  ...receipt("AUTHORITY", {
    decision: "AUTHORIZE_VALIDATION",
    authorized_by: "AUTHORIZED_HUMAN_FOR_DESIGN_ORCHARD_LLC",
    legal_authority: LEGAL_AUTHORITY,
    scope: "Execute the full UNI.XYZ validation workflow; canonical promotion remains conditional on every gate.",
    source_directive: "PRIVATE_AUTHORITY_DIRECTIVE_RECORDED",
    artifact_sha256: artifactSha256
  }),
  authorized_by: "AUTHORIZED_HUMAN_FOR_DESIGN_ORCHARD_LLC",
  legal_authority: LEGAL_AUTHORITY,
  decision: "AUTHORIZE_VALIDATION",
  scope: "Execute full validation; do not claim canonical promotion while any gate is blocked.",
  artifact_sha256: artifactSha256
};

const localPass = [
  ...abMatrix.map((item) => item.pass),
  ...expectedObserved.map((item) => item.pass),
  ...phases.map((item) => item.pass),
  ...negativeGates.map((item) => item.pass),
  ...adapters.map((item) => item.pass)
].every(Boolean);
const externalPass = externalReadbacks.every((item) => item.status === "PASS");

const results = {
  record_type: "UNI_XYZ_VALIDATION_EVIDENCE",
  generated_at: "2026-07-14T22:00:00.000Z",
  lifecycle_status: "VALIDATION",
  promotion_disposition: localPass && externalPass ? "PASS" : "HOLD",
  artifact_sha256: artifactSha256,
  validation_transition: validationTransition,
  summary: {
    local_pass: localPass,
    external_pass: externalPass,
    ab_cases: abMatrix.length,
    expected_observed_cases: expectedObserved.length,
    phase_cases: phases.length,
    negative_gate_cases: negativeGates.length,
    adapter_cases: adapters.length
  },
  ab_matrix: abMatrix,
  expected_observed: expectedObserved,
  phases,
  negative_gates: negativeGates,
  adapters,
  external_readbacks: externalReadbacks
};

await writeFile(join(evidenceDir, "validation-results.json"), `${JSON.stringify(results, null, 2)}\n`, "utf8");
await writeFile(join(evidenceDir, "VALIDATION_AUTHORITY_RECEIPT.json"), `${JSON.stringify(authorityReceipt, null, 2)}\n`, "utf8");
await writeFile(join(evidenceDir, "promotion-gate.json"), `${JSON.stringify({
  lifecycle_status: "VALIDATION",
  promotion_disposition: results.promotion_disposition,
  local_validation: localPass ? "PASS" : "BLOCK",
  external_validation: externalPass ? "PASS" : "BLOCK",
  gate: validationGate,
  blockers: externalReadbacks.filter((item) => item.status === "BLOCKED"),
  canonical_promotion_allowed: false
}, null, 2)}\n`, "utf8");

console.log(JSON.stringify(results.summary));
console.log(`artifact_sha256=${artifactSha256}`);
console.log(`promotion_disposition=${results.promotion_disposition}`);
