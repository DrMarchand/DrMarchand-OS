import {
  LEGAL_AUTHORITY,
  OPERATING_DBA,
  OPERATING_ENVIRONMENT,
  classifyPhase,
  runCycle
} from "../src/uni_xyz.mjs";

export function buildValidationObject(overrides = {}) {
  const authority = {
    legal_authority: LEGAL_AUTHORITY,
    operating_dba: OPERATING_DBA,
    operating_environment: OPERATING_ENVIRONMENT,
    authorized_by: "JK Marchand",
    authority_receipt: null
  };
  const command = {
    id: "CMD-UNI-XYZ-0001",
    intent: "Apply validated reference transition",
    issued_at: "2026-07-14T22:00:00.000Z",
    authority_status: "AUTHORIZED"
  };
  const currentState = { id: "state:before", value: 0 };
  const result = runCycle({
    command,
    authority,
    currentState,
    mutate: (state) => ({ ...state, id: "state:after", value: 1 }),
    boundary: "UNI.XYZ",
    expectedChange: true,
    betaBefore: { value: 0 },
    betaAfter: { value: 0 },
    different: true,
    connected: true
  });
  const phase = classifyPhase({
    freedom: 0.2,
    relationship_strength: 0.9,
    energy: 0.3,
    pressure: 0.7,
    constraints: 0.9,
    geometry: 0.9,
    tolerance: 0.1
  });

  const object = {
    object_id: "UNI.XYZ:validation-0001",
    schema_version: "0.1.0-validation",
    lifecycle_status: "VALIDATION",
    authority,
    source: {
      canonical_system: "GITHUB",
      repository: "DrMarchand/DrMarchand-OS",
      branch: "agent/uni-xyz-validation",
      path: "uni/xyz/UNI.XYZ_PROPOSED_CANON.md",
      commit_sha: null,
      blob_sha: null,
      artifact_sha256: null,
      derivative_of: "private-drive-registry:source-document:revision-4"
    },
    alpha: {
      id: "A",
      role: "ALPHA",
      mode: "AGGRESSIVE",
      state_before: result.previous_state,
      state_after: result.next_state
    },
    beta: {
      id: "B",
      role: "BETA",
      mode: "CALM",
      state_before: { value: 0 },
      state_after: { value: 0 }
    },
    command,
    cycle: result.cycle,
    observation: {
      ...result.observation,
      magnitude: 1,
      causal_claim: null
    },
    phase,
    evidence: result.evidence.map((item, index) => ({
      id: item.id,
      kind: index === 0 ? "INPUT" : index === 1 ? "EFFECT" : "SUCCESS",
      observed_at: item.observed_at,
      integrity_status: "VERIFIED",
      sha256: item.sha256,
      uri: null
    })),
    promotion: {
      gate_results: {
        identity: true,
        canon: true,
        reflection: true,
        drift: false,
        gate: false
      },
      zero_unexplained_drift: false,
      canonical_write_path: true,
      cross_system_readbacks: [
        { system: "GOOGLE_DRIVE", status: "PASS", receipt_id: "drive:hierarchy-pass" },
        { system: "ASANA", status: "BLOCKED", receipt_id: null },
        { system: "HUBSPOT", status: "BLOCKED", receipt_id: null },
        { system: "ICLOUD", status: "BLOCKED", receipt_id: null }
      ],
      authority_receipt_id: null,
      publication_receipt_id: null,
      disposition: "HOLD"
    },
    external_ids: {
      asana_project_id: "PRIVATE_PROJECT_REFERENCE",
      asana_task_id: "PRIVATE_TASK_REFERENCE",
      hubspot_expected_account_id: "PRIVATE_EXPECTED_PORTAL",
      hubspot_observed_account_id: "PRIVATE_CONNECTED_PORTAL",
      hubspot_record_id: null,
      google_drive_folder_id: "PRIVATE_DRIVE_REFERENCE",
      onedrive_url: null,
      icloud_status: "BLOCKED",
      github_url: "https://github.com/DrMarchand/DrMarchand-OS"
    }
  };
  return structuredClone({ ...object, ...overrides });
}
