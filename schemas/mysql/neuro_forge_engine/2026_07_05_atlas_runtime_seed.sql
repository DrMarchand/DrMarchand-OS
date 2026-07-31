-- DrMarchand’s ∞ OS™ / DrMarchand’s ⚙︎ Nɛuro-Forge Engine™
-- Atlas runtime seed
-- Target database machine identifier: Neuro-Forge_Engine
-- Purpose: create/populate registered Atlas nodes, edges, infrastructure references, bindings, and recorded truth states.
-- Evidence boundary: a schema or database row records state; it does not alone prove external health, reachability, authorization, or current deployment.
-- Safety: idempotent where possible. The public seed omits operational endpoints, account identifiers, filesystem paths, and credential-location metadata.

USE `Neuro-Forge_Engine`;

-- -----------------------------------------------------------------------------
-- 1. Core Atlas graph tables
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS atlas_nodes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    node_uuid CHAR(36) NOT NULL UNIQUE,
    node_key VARCHAR(120) NOT NULL UNIQUE,
    node_type VARCHAR(80) NOT NULL,
    display_name VARCHAR(255),
    database_name VARCHAR(120),
    table_name VARCHAR(120),
    parent_node VARCHAR(120),
    owner_system VARCHAR(120),
    truth_state VARCHAR(80),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS atlas_edges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    edge_uuid CHAR(36) NOT NULL UNIQUE,
    source_node_uuid CHAR(36) NOT NULL,
    target_node_uuid CHAR(36) NOT NULL,
    relationship_type VARCHAR(80) NOT NULL,
    direction ENUM('outbound', 'inbound', 'bidirectional') DEFAULT 'bidirectional',
    weight DECIMAL(8,2) DEFAULT 1.00,
    status VARCHAR(40) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_atlas_edge (source_node_uuid, target_node_uuid, relationship_type)
);

CREATE TABLE IF NOT EXISTS atlas_properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    property_uuid CHAR(36) NOT NULL UNIQUE,
    node_uuid CHAR(36) NOT NULL,
    property_key VARCHAR(120) NOT NULL,
    property_value TEXT,
    value_type VARCHAR(40) DEFAULT 'text',
    source_system VARCHAR(120),
    status VARCHAR(40) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_atlas_property (node_uuid, property_key)
);

-- -----------------------------------------------------------------------------
-- 2. Infrastructure and truth support tables
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS infrastructure_assets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asset_key VARCHAR(120) NOT NULL UNIQUE,
  asset_type VARCHAR(80) NOT NULL,
  provider VARCHAR(120),
  domain VARCHAR(255),
  server_host VARCHAR(255),
  shared_ip VARCHAR(80),
  cpanel_user VARCHAR(120),
  home_directory VARCHAR(255),
  credential_location VARCHAR(255) NOT NULL,
  ssl_status VARCHAR(80),
  status VARCHAR(80) DEFAULT 'active',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nfe_bindings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  binding_key VARCHAR(120) NOT NULL UNIQUE,
  source_system VARCHAR(120) NOT NULL,
  target_system VARCHAR(120) NOT NULL,
  binding_type VARCHAR(80) NOT NULL,
  purpose TEXT,
  status VARCHAR(80) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nfe_truth_states (
  id INT AUTO_INCREMENT PRIMARY KEY,
  object_key VARCHAR(120) NOT NULL,
  object_type VARCHAR(80) NOT NULL,
  truth_state VARCHAR(80) NOT NULL,
  verified_by VARCHAR(120),
  evidence TEXT,
  verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_truth_state (object_key, object_type)
);

-- -----------------------------------------------------------------------------
-- 3. Public infrastructure asset identities
-- -----------------------------------------------------------------------------
-- Operational endpoints, hosting-account identifiers, filesystem paths, and
-- credential-location metadata belong in a private runtime configuration or
-- approved secret-management system. This public seed registers only the
-- non-secret identity of each asset and never overwrites private runtime fields.

INSERT INTO infrastructure_assets
(asset_key, asset_type, provider, domain, credential_location, ssl_status, status, notes)
VALUES
('hosting_designorchard_net', 'cpanel_hosting', 'GoDaddy cPanel', 'designorchard.net', 'managed_outside_repository', 'unverified', 'active', 'Operational hosting metadata intentionally excluded from the public seed.'),
('hosting_kejstudio_com', 'cpanel_hosting', 'GoDaddy cPanel', 'kejstudio.com', 'managed_outside_repository', 'unverified', 'active', 'Operational hosting metadata intentionally excluded from the public seed.')
ON DUPLICATE KEY UPDATE
provider = VALUES(provider),
domain = VALUES(domain),
ssl_status = VALUES(ssl_status),
status = VALUES(status),
notes = VALUES(notes);

-- -----------------------------------------------------------------------------
-- 4. Core Atlas nodes
-- -----------------------------------------------------------------------------

INSERT INTO atlas_nodes
(node_uuid, node_key, node_type, display_name, database_name, table_name, parent_node, owner_system, truth_state)
VALUES
(UUID(), 'design_orchard_llc', 'legal_authority', 'Design Orchard LLC', 'DESIGN_ORCHARD_LLC', NULL, NULL, 'Design Orchard LLC', 'observed'),
(UUID(), 'design_orchard_service_island', 'service_surface', '🏝️ Design Orchard℠', NULL, NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'design_orchard_ecosystem', 'public_ecosystem', '🌴 Design Orchard™', NULL, NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'drmarchands_laboratory', 'delegated_operational_context', '🔬 DrMarchand’s Lab⚛︎ratory™', 'DrMarchands_Laboratory', NULL, 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'kej_studio', 'creative_operating_context', 'KEJ Studio', NULL, NULL, 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'drmarchand_os', 'presentation_interaction_system', 'DrMarchand’s ∞ OS™', NULL, NULL, 'drmarchands_laboratory', 'Design Orchard LLC', 'observed'),
(UUID(), 'neuro_forge_engine', 'bounded_execution_runtime', 'DrMarchand’s ⚙︎ Nɛuro-Forge Engine™', 'Neuro-Forge_Engine', NULL, 'drmarchands_laboratory', 'Design Orchard LLC', 'observed'),
(UUID(), 'uni', 'cross_system_namespace', 'UNI.XYZ', 'Neuro-Forge_Engine', NULL, 'drmarchands_laboratory', 'Design Orchard LLC', 'observed'),
(UUID(), 'atlas', 'truth_resolution_runtime', '🗺️ DrMarchand’s ⚛︎ Atlas', 'Neuro-Forge_Engine', 'atlas_nodes', 'drmarchands_laboratory', 'Design Orchard LLC', 'observed'),
(UUID(), 'flywheel', 'motion_layer', 'Flywheel', 'Neuro-Forge_Engine', NULL, 'neuro_forge_engine', 'Design Orchard LLC', 'observed'),
(UUID(), 'workbench', 'build_layer', '☸︎ Workbench', 'Neuro-Forge_Engine', NULL, 'drmarchands_laboratory', 'Design Orchard LLC', 'observed'),
(UUID(), 'drmarchands_library', 'permanent_record_custody', '📚 DrMarchand’s ⚛︎ Library™', 'DrMarchands_Library', NULL, 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'creative_canvas', 'creative_workspace', 'DrMarchand’s 🎨 Creative Canvas', NULL, NULL, 'kej_studio', 'Design Orchard LLC', 'planned'),
(UUID(), 'github_bridge_interface', 'external_bridge_interface', 'GitHub Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'google_drive_bridge_interface', 'external_bridge_interface', 'Google Drive Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'gemini_bridge_interface', 'external_bridge_interface', 'Gemini Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'hubspot_bridge_interface', 'external_bridge_interface', 'HubSpot Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'pandadoc_bridge_interface', 'external_bridge_interface', 'PandaDoc Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'discord_bridge_interface', 'external_bridge_interface', 'Discord Bridge Interface', NULL, NULL, NULL, 'Design Orchard LLC', 'planned'),
(UUID(), 'bookshelf_database', 'database', 'BOOKSHELF', 'BOOKSHELF', NULL, 'drmarchands_library', 'Design Orchard LLC', 'observed'),
(UUID(), 'library_database', 'database', 'LIBRARY', 'LIBRARY', NULL, 'drmarchands_library', 'Design Orchard LLC', 'observed'),
(UUID(), 'mms_database', 'database', 'MMS', 'MMS', NULL, 'neuro_forge_engine', 'Design Orchard LLC', 'observed'),
(UUID(), 'cloud_database', 'database', 'CLOUD', 'CLOUD', NULL, 'neuro_forge_engine', 'Design Orchard LLC', 'observed'),
(UUID(), 'design_orchard_llc_database', 'database', 'DESIGN_ORCHARD_LLC', 'DESIGN_ORCHARD_LLC', NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'neuro_forge_engine_database', 'database', 'Neuro-Forge_Engine', 'Neuro-Forge_Engine', NULL, 'neuro_forge_engine', 'Design Orchard LLC', 'observed'),
(UUID(), 'hosting_designorchard_net', 'infrastructure_asset', 'designorchard.net cPanel Hosting', 'Neuro-Forge_Engine', 'infrastructure_assets', 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'hosting_kejstudio_com', 'infrastructure_asset', 'kejstudio.com cPanel Hosting', 'Neuro-Forge_Engine', 'infrastructure_assets', 'creative_canvas', 'Design Orchard LLC', 'observed'),
(UUID(), 'github_repo_drmarchand_os', 'repository', 'GitHub Repository: DrMarchand/DrMarchand-OS', NULL, NULL, 'drmarchand_os', 'Design Orchard LLC', 'observed'),
(UUID(), 'google_drive_pressure_test_layer', 'external_documentation_bridge', 'Google Drive Documentation and Pressure-Test Bridge', NULL, NULL, NULL, 'Design Orchard LLC', 'observed')
ON DUPLICATE KEY UPDATE
node_type = VALUES(node_type),
display_name = VALUES(display_name),
database_name = VALUES(database_name),
table_name = VALUES(table_name),
parent_node = VALUES(parent_node),
owner_system = VALUES(owner_system),
truth_state = VALUES(truth_state);

-- -----------------------------------------------------------------------------
-- 5. Atlas relationship edges
-- -----------------------------------------------------------------------------
-- Preserve superseded relationship rows as historical graph evidence rather
-- than deleting them. New relationships below express current authority and
-- functional boundaries.

UPDATE atlas_edges e
JOIN atlas_nodes s ON s.node_uuid = e.source_node_uuid
JOIN atlas_nodes t ON t.node_uuid = e.target_node_uuid
SET e.status = 'superseded'
WHERE e.status = 'active'
  AND (
    (s.node_key = 'drmarchands_laboratory'
      AND t.node_key IN ('drmarchands_library', 'creative_canvas')
      AND e.relationship_type = 'contains')
    OR (s.node_key = 'drmarchand_os' AND e.relationship_type = 'contains')
    OR (s.node_key = 'neuro_forge_engine' AND e.relationship_type = 'contains')
    OR (s.node_key = 'uni' AND e.relationship_type = 'supports')
    OR (e.relationship_type = 'connects_to_external_service')
  );

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'owns', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'design_orchard_llc' AND t.node_key = 'design_orchard_ecosystem'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'offers_services_through', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'design_orchard_llc' AND t.node_key = 'design_orchard_service_island'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'contains', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'design_orchard_ecosystem'
  AND t.node_key IN ('drmarchands_laboratory', 'drmarchands_library', 'kej_studio')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'contains', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchands_laboratory' AND t.node_key = 'drmarchand_os'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'delegates_execution_to', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchands_laboratory' AND t.node_key = 'neuro_forge_engine'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'registers_state_with', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'neuro_forge_engine' AND t.node_key = 'atlas'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'presents_registered_state_from', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key = 'atlas'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'routes_authorized_requests_to', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key = 'neuro_forge_engine'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'routes_approved_records_to', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key = 'drmarchands_library'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'operates', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'kej_studio' AND t.node_key = 'creative_canvas'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'uses_runtime_component', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'neuro_forge_engine'
  AND t.node_key IN ('flywheel', 'workbench', 'mms_database', 'cloud_database', 'neuro_forge_engine_database')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'uses_custody_database', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchands_library'
  AND t.node_key IN ('bookshelf_database', 'library_database')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'provides_cross_system_namespace_to', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'uni'
  AND t.node_key IN ('neuro_forge_engine', 'atlas', 'drmarchand_os')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'indexes', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'atlas'
  AND t.node_key IN ('bookshelf_database', 'library_database', 'mms_database', 'cloud_database', 'design_orchard_llc_database', 'neuro_forge_engine_database', 'hosting_designorchard_net', 'hosting_kejstudio_com')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'connects_via_external_bridge', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'neuro_forge_engine'
  AND t.node_key IN ('github_bridge_interface', 'google_drive_bridge_interface', 'gemini_bridge_interface', 'discord_bridge_interface')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'connects_via_external_bridge', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'creative_canvas'
  AND t.node_key IN ('hubspot_bridge_interface', 'pandadoc_bridge_interface', 'discord_bridge_interface')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'versioned_in', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key = 'github_repo_drmarchand_os'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'documents_through_external_bridge', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key = 'google_drive_pressure_test_layer'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'hosted_on', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'design_orchard_ecosystem' AND t.node_key = 'hosting_designorchard_net'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'hosted_on', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'creative_canvas' AND t.node_key = 'hosting_kejstudio_com'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

-- -----------------------------------------------------------------------------
-- 6. Atlas properties with evidence references
-- -----------------------------------------------------------------------------

INSERT INTO atlas_properties
(property_uuid, node_uuid, property_key, property_value, value_type, source_system, status)
SELECT UUID(), n.node_uuid, 'evidence_google_drive_milestone', 'MILESTONE_20260702_PREVIEW_LIVE_SPLIT_IDENTITY_AUTHORITY_MODEL', 'text', 'Google Drive', 'active'
FROM atlas_nodes n WHERE n.node_key IN ('design_orchard_llc','drmarchands_laboratory','neuro_forge_engine','drmarchand_os')
ON DUPLICATE KEY UPDATE property_value = VALUES(property_value), source_system = VALUES(source_system), status = VALUES(status);

INSERT INTO atlas_properties
(property_uuid, node_uuid, property_key, property_value, value_type, source_system, status)
SELECT UUID(), n.node_uuid, 'evidence_github_registry', 'registry/CORE_ARCHITECTURE.md', 'path', 'GitHub', 'active'
FROM atlas_nodes n WHERE n.node_key IN ('drmarchand_os','uni','atlas','flywheel','workbench','neuro_forge_engine')
ON DUPLICATE KEY UPDATE property_value = VALUES(property_value), source_system = VALUES(source_system), status = VALUES(status);

-- -----------------------------------------------------------------------------
-- 7. Engine bindings
-- -----------------------------------------------------------------------------

INSERT INTO nfe_bindings
(binding_key, source_system, target_system, binding_type, purpose, status)
VALUES
('binding_atlas_to_infrastructure_assets', 'atlas', 'infrastructure_assets', 'indexes', '🗺️ DrMarchand’s ⚛︎ Atlas indexes registered infrastructure asset identities.', 'active'),
('binding_engine_to_atlas', 'neuro_forge_engine', 'atlas', 'registers_state_with', 'DrMarchand’s ⚙︎ Nɛuro-Forge Engine™ registers execution state with 🗺️ DrMarchand’s ⚛︎ Atlas.', 'active'),
('binding_os_to_atlas', 'drmarchand_os', 'atlas', 'presents_registered_state_from', 'DrMarchand’s ∞ OS™ presents registered state resolved through 🗺️ DrMarchand’s ⚛︎ Atlas.', 'active'),
('binding_os_to_engine', 'drmarchand_os', 'neuro_forge_engine', 'routes_authorized_requests_to', 'DrMarchand’s ∞ OS™ routes authorized requests to the bounded Engine runtime.', 'active'),
('binding_atlas_to_google_drive_evidence', 'atlas', 'google_drive_pressure_test_layer', 'documents_through_external_bridge', 'Atlas records may reference evidence reached through the external Google Drive Bridge.', 'active'),
('binding_atlas_to_github_registry', 'atlas', 'github_repo_drmarchand_os', 'references_versioned_artifact', 'Atlas records may reference versioned engineering artifacts in GitHub.', 'active'),
('binding_uni_to_atlas', 'uni', 'atlas', 'provides_cross_system_namespace_to', 'UNI.XYZ provides cross-system namespace structure used by Atlas records.', 'active'),
('binding_creative_canvas_to_hubspot', 'creative_canvas', 'hubspot_bridge_interface', 'external_bridge_interface', 'DrMarchand’s 🎨 Creative Canvas routes CRM operations through an external HubSpot Bridge.', 'planned'),
('binding_creative_canvas_to_pandadoc', 'creative_canvas', 'pandadoc_bridge_interface', 'external_bridge_interface', 'DrMarchand’s 🎨 Creative Canvas routes proposal and contract operations through an external PandaDoc Bridge.', 'planned'),
('binding_creative_canvas_to_discord', 'creative_canvas', 'discord_bridge_interface', 'external_bridge_interface', 'DrMarchand’s 🎨 Creative Canvas routes notifications through an external Discord Bridge.', 'planned')
ON DUPLICATE KEY UPDATE
source_system = VALUES(source_system),
target_system = VALUES(target_system),
binding_type = VALUES(binding_type),
purpose = VALUES(purpose),
status = VALUES(status);

-- -----------------------------------------------------------------------------
-- 8. Truth states
-- -----------------------------------------------------------------------------

INSERT INTO nfe_truth_states
(object_key, object_type, truth_state, verified_by, evidence)
VALUES
('infrastructure_assets', 'table', 'observed', 'manual_phpmyadmin_screenshot', 'Table created and two cPanel hosting assets inserted.'),
('atlas_nodes', 'table', 'observed', 'manual_phpmyadmin_screenshot', 'Atlas nodes table created in Neuro-Forge_Engine.'),
('atlas_edges', 'table', 'observed', 'manual_phpmyadmin_screenshot', 'Atlas edges table created in Neuro-Forge_Engine.'),
('github_repo_drmarchand_os', 'repository', 'observed', 'GitHub connector', 'Repository DrMarchand/DrMarchand-OS exists and contains registry/CORE_ARCHITECTURE.md.'),
('google_drive_pressure_test_layer', 'documentation_bridge', 'observed', 'Google Drive connector', 'Drive milestone identifies Google Drive Documentation and Pressure-Test Bridge.'),
('hosting_designorchard_net', 'infrastructure_asset', 'observed', 'manual_cpanel_screenshot', 'Public seed records the asset identity only; operational metadata is managed outside the repository.'),
('hosting_kejstudio_com', 'infrastructure_asset', 'observed', 'manual_cpanel_screenshot', 'cPanel hosting metadata recorded. Password excluded.')
ON DUPLICATE KEY UPDATE
truth_state = VALUES(truth_state),
verified_by = VALUES(verified_by),
evidence = VALUES(evidence),
verified_at = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 9. Validation queries
-- -----------------------------------------------------------------------------

SELECT 'atlas_nodes' AS table_name, COUNT(*) AS total_rows FROM atlas_nodes
UNION ALL
SELECT 'atlas_edges' AS table_name, COUNT(*) AS total_rows FROM atlas_edges
UNION ALL
SELECT 'atlas_properties' AS table_name, COUNT(*) AS total_rows FROM atlas_properties
UNION ALL
SELECT 'infrastructure_assets' AS table_name, COUNT(*) AS total_rows FROM infrastructure_assets
UNION ALL
SELECT 'nfe_bindings' AS table_name, COUNT(*) AS total_rows FROM nfe_bindings
UNION ALL
SELECT 'nfe_truth_states' AS table_name, COUNT(*) AS total_rows FROM nfe_truth_states;
