import test from "node:test";
import assert from "node:assert/strict";

import {
  LEGAL_AUTHORITY,
  Lifecycle,
  OPERATING_DBA,
  bigBrotherObserve,
  breathe,
  classifyExpectedObserved,
  classifyPhase,
  digest,
  lionheartGate,
  observe,
  phoenixSubmitCommand,
  receipt,
  roundTripAdapter,
  runCycle,
  semanticDelta,
  transitionLifecycle
} from "../src/uni_xyz.mjs";

const authorizedAuthority = {
  legal_authority: LEGAL_AUTHORITY,
  operating_dba: OPERATING_DBA,
  authorized_by: "JK Marchand"
};

test("all sixteen A/B configurations preserve independent dimensions", () => {
  const cases = [];
  for (const alphaChanged of [false, true]) {
    for (const betaChanged of [false, true]) {
      for (const different of [false, true]) {
        for (const connected of [false, true]) {
          const observation = observe({
            alphaBefore: { value: 0 },
            alphaAfter: { value: alphaChanged ? 1 : 0 },
            betaBefore: { value: 0 },
            betaAfter: { value: betaChanged ? 1 : 0 },
            different,
            connected,
            expectedChange: alphaChanged || betaChanged
          });
          assert.equal(observation.alpha_changed, alphaChanged);
          assert.equal(observation.beta_changed, betaChanged);
          assert.equal(observation.different, different);
          assert.equal(observation.connected, connected);
          cases.push(observation);
        }
      }
    }
  }
  assert.equal(cases.length, 16);
  assert.equal(new Set(cases.map((item) => JSON.stringify([
    item.alpha_changed,
    item.beta_changed,
    item.different,
    item.connected
  ]))).size, 16);
});

test("expected versus observed maps to all four canonical classifications", () => {
  assert.equal(classifyExpectedObserved(true, true), "CONFIRMED_CAPABILITY_CANDIDATE");
  assert.equal(classifyExpectedObserved(true, false), "FAILURE_OR_RESISTANCE");
  assert.equal(classifyExpectedObserved(false, true), "SIDE_EFFECT_OR_DISCOVERY");
  assert.equal(classifyExpectedObserved(false, false), "STABILITY_OR_INERT");
});

test("BREATHE requires a direction and preserves boundary identity", () => {
  const inhale = breathe({
    direction: "IN",
    boundary: "UNI.XYZ",
    payloadType: "CONTEXT",
    payload: { value: 1 }
  });
  const exhale = breathe({
    direction: "OUT",
    boundary: "UNI.XYZ",
    payloadType: "EVIDENCE",
    payload: { value: 2 }
  });
  assert.equal(inhale.exchange.boundary_identity_before, inhale.exchange.boundary_identity_after);
  assert.equal(exhale.exchange.boundary_identity_before, exhale.exchange.boundary_identity_after);
  assert.notEqual(inhale.evidence.id, exhale.evidence.id);
  assert.throws(() => breathe({ direction: "SIDEWAYS", boundary: "UNI.XYZ", payloadType: "CONTEXT", payload: {} }));
});

test("denied command cannot mutate authoritative state and returns evidence to REST", () => {
  const state = { id: "state:one", value: 0 };
  const cycle = runCycle({
    command: {
      id: "CMD-DENIED",
      intent: "Attempt forbidden mutation",
      issued_at: "2026-07-14T22:00:00.000Z",
      authority_status: "DENIED"
    },
    authority: authorizedAuthority,
    currentState: state,
    mutate: (value) => ({ ...value, value: 999 }),
    boundary: "UNI.XYZ",
    expectedChange: false
  });
  assert.deepEqual(cycle.next_state, state);
  assert.equal(cycle.cycle.delta.authorized, false);
  assert.equal(cycle.cycle.delta.mutation_applied, false);
  assert.equal(cycle.cycle.delta.next_state_id, null);
  assert.equal(cycle.cycle.delta.previous_state_digest, cycle.cycle.delta.next_state_digest);
  assert.equal(cycle.cycle.theta.disposition, "ASSIMILATE");
  assert.equal(cycle.evidence.length, 3);
});

test("authorized command mutates and emits a non-null effect receipt", () => {
  const cycle = runCycle({
    command: {
      id: "CMD-AUTHORIZED",
      intent: "Apply governed mutation",
      issued_at: "2026-07-14T22:00:00.000Z",
      authority_status: "AUTHORIZED"
    },
    authority: authorizedAuthority,
    currentState: { id: "state:one", value: 0 },
    mutate: (value) => ({ ...value, id: "state:two", value: 1 }),
    boundary: "UNI.XYZ",
    expectedChange: true
  });
  assert.equal(cycle.cycle.delta.authorized, true);
  assert.equal(cycle.cycle.delta.mutation_applied, true);
  assert.ok(cycle.cycle.delta.effect_receipt_id);
  assert.equal(cycle.next_state.value, 1);
  assert.equal(cycle.cycle.theta.disposition, "ASSIMILATE");
});

test("phase classification requires measurements and resolves four reference phases", () => {
  assert.equal(classifyPhase({ freedom: 0.2, relationship_strength: 0.1, energy: 0.2, pressure: 0.1, constraints: 0.1, geometry: 0.1, tolerance: 0.8 }).classification, "PARTICLE");
  assert.equal(classifyPhase({ freedom: 0.9, relationship_strength: 0.2, energy: 0.8, pressure: 0.1, constraints: 0.2, geometry: 0.2, tolerance: 0.8 }).classification, "GAS");
  assert.equal(classifyPhase({ freedom: 0.6, relationship_strength: 0.6, energy: 0.5, pressure: 0.5, constraints: 0.5, geometry: 0.5, tolerance: 0.5 }).classification, "LIQUID");
  assert.equal(classifyPhase({ freedom: 0.2, relationship_strength: 0.9, energy: 0.3, pressure: 0.8, constraints: 0.9, geometry: 0.9, tolerance: 0.1 }).classification, "SOLID");
  assert.throws(() => classifyPhase({ classification: "SOLID" }));
});

test("each Lionheart integrity failure independently blocks the gate", () => {
  const checks = ["identity", "canon", "reflection", "drift", "gate"];
  assert.equal(lionheartGate(Object.fromEntries(checks.map((key) => [key, true]))).passed, true);
  for (const failed of checks) {
    const values = Object.fromEntries(checks.map((key) => [key, key !== failed]));
    const result = lionheartGate(values);
    assert.equal(result.passed, false);
    assert.deepEqual(result.failed, [failed]);
    assert.equal(result.disposition, "BLOCK");
  }
});

test("Big Brother observes drift without mutating the authoritative object", () => {
  const state = { object_id: "UNI.XYZ:test", nested: { value: 1 } };
  const before = digest(state);
  const report = bigBrotherObserve(state, before);
  assert.equal(report.drift, false);
  assert.equal(digest(state), before);
  assert.notEqual(report.state_snapshot, state);
});

test("platform adapters preserve semantic invariants while presentation may vary", () => {
  const object = {
    object_id: "UNI.XYZ:test",
    authority: authorizedAuthority,
    permitted_commands: ["CMD-A"],
    evidence_requirements: ["EFFECT_RECEIPT"],
    semantic_behavior: { mode: "GOVERNED" },
    noncanonical_presentation: { color: "navy" }
  };
  for (const platform of ["PHOENIX_SWIFTUI", "CHROMEOS_BOOTSTRAP", "WINDOWS", "ANDROID"]) {
    const roundTrip = roundTripAdapter(platform, object, { color: platform });
    assert.equal(semanticDelta(object, roundTrip.object).changed, false);
  }
  const changed = structuredClone(object);
  changed.semantic_behavior.mode = "UNSAFE";
  assert.equal(semanticDelta(object, changed).changed, true);
});

test("Phoenix submits commands and cannot directly claim an authoritative mutation", () => {
  const submission = phoenixSubmitCommand({ id: "CMD-PHOENIX", intent: "Request transition" });
  assert.equal(submission.action, "SUBMIT_COMMAND");
  assert.equal(submission.authoritative_mutation, false);
  assert.equal(Object.isFrozen(submission), true);
});

test("lifecycle rejects direct promotion and requires receipts at approval boundaries", () => {
  const passGate = lionheartGate({ identity: true, canon: true, reflection: true, drift: true, gate: true });
  const authorityReceipt = receipt("AUTHORITY", { decision: "APPROVE_PROMOTION" });
  const publicationReceipt = receipt("PUBLICATION", { commit_sha: "a".repeat(40) });
  assert.throws(() => transitionLifecycle({ current: Lifecycle.PROPOSED, target: Lifecycle.CANONICAL, gate: passGate, authorityReceipt, publicationReceipt }));
  assert.throws(() => transitionLifecycle({ current: Lifecycle.VALIDATION, target: Lifecycle.APPROVED, gate: passGate }));
  assert.ok(transitionLifecycle({ current: Lifecycle.VALIDATION, target: Lifecycle.APPROVED, gate: passGate, authorityReceipt }).id);
  assert.ok(transitionLifecycle({ current: Lifecycle.APPROVED, target: Lifecycle.CANONICAL, gate: passGate, authorityReceipt, publicationReceipt }).id);
});
