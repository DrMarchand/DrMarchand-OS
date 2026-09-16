import { createHash } from "node:crypto";

export const LEGAL_AUTHORITY = "Design Orchard LLC";
export const OPERATING_DBA = "DrMarchand’s Laboratory";
export const OPERATING_ENVIRONMENT = "🔬 DrMarchand’s Lab⚛︎ratory™";
export const ENGINE = "DrMarchand’s ⚙︎ Nɛuro-Forge Engine™";

export const Lifecycle = Object.freeze({
  WORKING: "WORKING",
  PROPOSED: "PROPOSED_PROMOTION_DRAFT",
  VALIDATION: "VALIDATION",
  APPROVED: "APPROVED",
  CANONICAL: "CANONICAL",
  SUPERSEDED: "SUPERSEDED"
});

const TRANSITIONS = Object.freeze({
  [Lifecycle.WORKING]: new Set([Lifecycle.PROPOSED]),
  [Lifecycle.PROPOSED]: new Set([Lifecycle.VALIDATION]),
  [Lifecycle.VALIDATION]: new Set([Lifecycle.PROPOSED, Lifecycle.APPROVED]),
  [Lifecycle.APPROVED]: new Set([Lifecycle.VALIDATION, Lifecycle.CANONICAL]),
  [Lifecycle.CANONICAL]: new Set([Lifecycle.SUPERSEDED]),
  [Lifecycle.SUPERSEDED]: new Set()
});

function canonicalize(value) {
  if (Array.isArray(value)) return value.map(canonicalize);
  if (value && typeof value === "object") {
    return Object.fromEntries(
      Object.keys(value).sort().map((key) => [key, canonicalize(value[key])])
    );
  }
  return value;
}

export function stableJson(value) {
  return JSON.stringify(canonicalize(value));
}

export function digest(value) {
  return createHash("sha256").update(stableJson(value), "utf8").digest("hex");
}

export function receipt(kind, payload, observedAt = "2026-07-14T22:00:00.000Z") {
  const body = { kind, observed_at: observedAt, payload: canonicalize(payload) };
  return {
    id: `${kind.toLowerCase()}:${digest(body).slice(0, 24)}`,
    ...body,
    sha256: digest(body)
  };
}

export function classifyExpectedObserved(expectedChange, observedChange) {
  if (expectedChange && observedChange) return "CONFIRMED_CAPABILITY_CANDIDATE";
  if (expectedChange && !observedChange) return "FAILURE_OR_RESISTANCE";
  if (!expectedChange && observedChange) return "SIDE_EFFECT_OR_DISCOVERY";
  return "STABILITY_OR_INERT";
}

export function observe({
  alphaBefore,
  alphaAfter,
  betaBefore,
  betaAfter,
  different,
  connected,
  expectedChange
}) {
  const alphaChanged = stableJson(alphaBefore) !== stableJson(alphaAfter);
  const betaChanged = stableJson(betaBefore) !== stableJson(betaAfter);
  const observedChange = alphaChanged || betaChanged;
  return {
    alpha_changed: alphaChanged,
    beta_changed: betaChanged,
    different: Boolean(different),
    connected: Boolean(connected),
    expected_change: Boolean(expectedChange),
    observed_change: observedChange,
    classification: classifyExpectedObserved(Boolean(expectedChange), observedChange)
  };
}

export function breathe({ direction, boundary, payloadType, payload, conditions = {} }) {
  if (!new Set(["IN", "OUT"]).has(direction)) {
    throw new Error(`Unsupported BREATHE direction: ${direction}`);
  }
  if (!boundary || !payloadType) throw new Error("BREATHE requires boundary and payload type");
  const boundaryIdentity = digest({ boundary });
  const evidence = receipt(`BREATHE_${direction}`, {
    function: "BREATHE",
    direction,
    boundary,
    payload_type: payloadType,
    payload_digest: digest(payload),
    conditions
  });
  return {
    exchange: {
      direction,
      boundary,
      payload_type: payloadType,
      receipt_id: evidence.id,
      boundary_identity_before: boundaryIdentity,
      boundary_identity_after: boundaryIdentity
    },
    evidence
  };
}

export function authorityDecision(command, authority) {
  const authorized =
    command.authority_status === "AUTHORIZED" &&
    authority?.legal_authority === LEGAL_AUTHORITY &&
    authority?.operating_dba === OPERATING_DBA &&
    typeof authority?.authorized_by === "string" &&
    authority.authorized_by.trim().length > 0;

  return {
    authorized,
    reason: authorized ? "EXPLICIT_AUTHORITY_CONFIRMED" : "AUTHORITY_ABSENT_OR_DENIED"
  };
}

export function react({ command, authority, currentState, mutate }) {
  const decision = authorityDecision(command, authority);
  const previousState = structuredClone(currentState);
  const previousDigest = digest(previousState);

  if (!decision.authorized) {
    const denial = receipt("REACTION_DENIED", {
      command_id: command.id,
      authority_status: command.authority_status,
      previous_state_digest: previousDigest,
      reason: decision.reason
    });
    return {
      next_state: previousState,
      delta: {
        function: "REACT",
        authorized: false,
        mutation_applied: false,
        effect_receipt_id: denial.id,
        previous_state_digest: previousDigest,
        next_state_digest: previousDigest,
        next_state_id: null
      },
      evidence: denial
    };
  }

  if (typeof mutate !== "function") throw new Error("Authorized REACT requires a mutation function");
  const nextState = structuredClone(mutate(structuredClone(previousState)));
  const nextDigest = digest(nextState);
  const effect = receipt("REACTION_EFFECT", {
    command_id: command.id,
    previous_state_digest: previousDigest,
    next_state_digest: nextDigest
  });

  return {
    next_state: nextState,
    delta: {
      function: "REACT",
      authorized: true,
      mutation_applied: previousDigest !== nextDigest,
      effect_receipt_id: effect.id,
      previous_state_digest: previousDigest,
      next_state_digest: nextDigest,
      next_state_id: nextState.id ?? `state:${nextDigest.slice(0, 24)}`
    },
    evidence: effect
  };
}

export function rest({ wisdomBefore = {}, expectedChange, observation, evidence = [] }) {
  const disposition = observation.observed_change === Boolean(expectedChange)
    ? "ASSIMILATE"
    : "ESCALATE";
  const worked = disposition === "ASSIMILATE" ? [observation.classification] : [];
  const failed = disposition === "ESCALATE" ? [observation.classification] : [];
  const unresolved = observation.classification === "SIDE_EFFECT_OR_DISCOVERY"
    ? ["CAUSAL_REVIEW_REQUIRED"]
    : [];
  const wisdomAfter = {
    ...structuredClone(wisdomBefore),
    last_classification: observation.classification,
    evidence_ids: evidence.map((item) => item.id),
    disposition
  };
  return {
    function: "REST",
    wisdom_before: structuredClone(wisdomBefore),
    wisdom_after: wisdomAfter,
    worked,
    failed,
    unresolved,
    evidence_ids: evidence.map((item) => item.id),
    disposition
  };
}

export function runCycle({
  command,
  authority,
  currentState,
  mutate,
  boundary,
  payloadType = "CONTEXT",
  expectedChange = false,
  betaBefore = {},
  betaAfter = {},
  different = true,
  connected = true,
  wisdomBefore = {}
}) {
  const inhale = breathe({
    direction: "IN",
    boundary,
    payloadType,
    payload: { command, current_state_digest: digest(currentState) }
  });
  const reaction = react({ command, authority, currentState, mutate });
  const observation = observe({
    alphaBefore: currentState,
    alphaAfter: reaction.next_state,
    betaBefore,
    betaAfter,
    different,
    connected,
    expectedChange
  });
  const exhale = breathe({
    direction: "OUT",
    boundary,
    payloadType: "EVIDENCE",
    payload: { delta: reaction.delta, observation, evidence: reaction.evidence }
  });
  const theta = rest({
    wisdomBefore,
    expectedChange,
    observation,
    evidence: [inhale.evidence, reaction.evidence, exhale.evidence]
  });
  return {
    previous_state: structuredClone(currentState),
    next_state: reaction.next_state,
    cycle: {
      theta,
      breathe: [inhale.exchange, exhale.exchange],
      delta: reaction.delta
    },
    observation,
    evidence: [inhale.evidence, reaction.evidence, exhale.evidence]
  };
}

export function classifyPhase(measurements) {
  const required = [
    "freedom",
    "relationship_strength",
    "energy",
    "pressure",
    "constraints",
    "geometry",
    "tolerance"
  ];
  for (const key of required) {
    if (typeof measurements?.[key] !== "number") {
      throw new Error(`Phase classification requires numeric ${key}`);
    }
  }
  const m = measurements;
  let classification;
  if (m.relationship_strength < 0.25 && m.constraints < 0.25 && m.freedom < 0.35) {
    classification = "PARTICLE";
  } else if (m.freedom >= 0.75 && m.relationship_strength < 0.4 && m.constraints < 0.4) {
    classification = "GAS";
  } else if (m.freedom >= 0.4 && m.relationship_strength >= 0.4 && m.constraints < 0.75) {
    classification = "LIQUID";
  } else if (
    m.relationship_strength >= 0.7 &&
    m.constraints >= 0.7 &&
    m.geometry >= 0.7 &&
    m.tolerance <= 0.3
  ) {
    classification = "SOLID";
  } else {
    classification = "UNRESOLVED";
  }
  return {
    classification,
    measurements: structuredClone(measurements),
    model: "COMPUTATIONAL_ONTOLOGY_REFERENCE_0.1.0",
    scientific_law_claim: false
  };
}

export function lionheartGate(checks) {
  const names = ["identity", "canon", "reflection", "drift", "gate"];
  const results = Object.fromEntries(names.map((name) => [name, checks?.[name] === true]));
  const failed = names.filter((name) => !results[name]);
  return {
    results,
    passed: failed.length === 0,
    failed,
    disposition: failed.length === 0 ? "PASS" : "BLOCK"
  };
}

export function bigBrotherObserve(state, expectedDigest) {
  const observed = structuredClone(state);
  const observedDigest = digest(observed);
  return Object.freeze({
    role: "OBSERVE_ONLY",
    observed_digest: observedDigest,
    expected_digest: expectedDigest,
    drift: observedDigest !== expectedDigest,
    state_snapshot: observed
  });
}

const INVARIANT_KEYS = Object.freeze([
  "object_id",
  "authority",
  "permitted_commands",
  "evidence_requirements",
  "semantic_behavior"
]);

export function invariantProjection(object) {
  return Object.fromEntries(INVARIANT_KEYS.map((key) => [key, structuredClone(object[key])]));
}

export function renderAdapter(platform, object, presentation = {}) {
  const supported = new Set(["PHOENIX_SWIFTUI", "CHROMEOS_BOOTSTRAP", "WINDOWS", "ANDROID"]);
  if (!supported.has(platform)) throw new Error(`Unsupported adapter: ${platform}`);
  return {
    platform,
    invariants: invariantProjection(object),
    invariant_digest: digest(invariantProjection(object)),
    presentation: structuredClone(presentation),
    presentation_digest: digest(presentation),
    commands_only: true
  };
}

export function roundTripAdapter(platform, object, presentation = {}) {
  const rendered = renderAdapter(platform, object, presentation);
  return {
    object: {
      ...structuredClone(object),
      ...structuredClone(rendered.invariants)
    },
    receipt: receipt("ADAPTER_ROUND_TRIP", {
      platform,
      invariant_digest: rendered.invariant_digest,
      presentation_digest: rendered.presentation_digest
    })
  };
}

export function semanticDelta(before, after) {
  const beforeInvariant = invariantProjection(before);
  const afterInvariant = invariantProjection(after);
  return {
    changed: digest(beforeInvariant) !== digest(afterInvariant),
    before_digest: digest(beforeInvariant),
    after_digest: digest(afterInvariant)
  };
}

export function phoenixSubmitCommand(command) {
  return Object.freeze({
    platform: "PHOENIX_SWIFTUI",
    action: "SUBMIT_COMMAND",
    command: structuredClone(command),
    authoritative_mutation: false
  });
}

export function transitionLifecycle({ current, target, gate, authorityReceipt, publicationReceipt }) {
  if (!TRANSITIONS[current]?.has(target)) {
    throw new Error(`Illegal lifecycle transition: ${current} -> ${target}`);
  }
  if (target === Lifecycle.APPROVED) {
    if (!gate?.passed || !authorityReceipt?.id) {
      throw new Error("APPROVED requires passing gates and an authority receipt");
    }
  }
  if (target === Lifecycle.CANONICAL) {
    if (!gate?.passed || !authorityReceipt?.id || !publicationReceipt?.id) {
      throw new Error("CANONICAL requires passing gates, authority, and publication receipts");
    }
  }
  return receipt("LIFECYCLE_TRANSITION", {
    from: current,
    to: target,
    gate_digest: gate ? digest(gate) : null,
    authority_receipt_id: authorityReceipt?.id ?? null,
    publication_receipt_id: publicationReceipt?.id ?? null
  });
}
