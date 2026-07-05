-- DrMarchand-OS / Neuro-Forge Engine
-- Atlas runtime seed
-- Target database: Neuro-Forge_Engine
-- Purpose: create/populate Atlas nodes, Atlas edges, runtime infrastructure references, and verification records.
-- Safety: idempotent where possible. Does not store passwords, tokens, API keys, SSH keys, or recovery codes.

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
-- 3. Infrastructure assets from cPanel evidence
-- -----------------------------------------------------------------------------

INSERT INTO infrastructure_assets
(asset_key, asset_type, provider, domain, server_host, shared_ip, cpanel_user, home_directory, credential_location, ssl_status, status, notes)
VALUES
('hosting_designorchard_net', 'cpanel_hosting', 'GoDaddy cPanel', 'designorchard.net', 'secureserver.net', '132.148.176.255', 'cx1vycihumh7', '/home/cx1vycihumh7', 'Password Vault > Design Orchard LLC > cPanel - designorchard.net', 'self_signed_needs_replacement', 'active', 'Primary Design Orchard hosting account. Do not store password in database.'),
('hosting_kejstudio_com', 'cpanel_hosting', 'GoDaddy cPanel', 'kejstudio.com', 'secureserver.net', '132.148.179.19', 'mucbfl83wr27', '/home/mucbfl83wr27', 'Password Vault > Design Orchard LLC > cPanel - kejstudio.com', 'self_signed_needs_replacement', 'active', 'KEJ Studio hosting account. Do not store password in database.')
ON DUPLICATE KEY UPDATE
provider = VALUES(provider),
domain = VALUES(domain),
server_host = VALUES(server_host),
shared_ip = VALUES(shared_ip),
cpanel_user = VALUES(cpanel_user),
home_directory = VALUES(home_directory),
credential_location = VALUES(credential_location),
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
(UUID(), 'design_orchard_service_island', 'service_surface', 'Design Orchard Service Island', NULL, NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'design_orchard_ecosystem', 'public_ecosystem', 'Design Orchard', NULL, NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'drmarchands_laboratory', 'laboratory', 'DrMarchand Laboratory', 'DrMarchands_Laboratory', NULL, 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'drmarchand_os', 'engine_core_repository', 'DrMarchand-OS', NULL, NULL, 'drmarchands_laboratory', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'neuro_forge_engine', 'runtime_engine', 'Neuro-Forge Engine', 'Neuro-Forge_Engine', NULL, 'drmarchand_os', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'uni', 'gear_system', 'UNI', 'Neuro-Forge_Engine', NULL, 'drmarchand_os', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'atlas', 'map_layer', 'Atlas', 'Neuro-Forge_Engine', 'atlas_nodes', 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'flywheel', 'motion_layer', 'Flywheel', 'Neuro-Forge_Engine', NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'workbench', 'build_layer', 'Workbench', 'Neuro-Forge_Engine', NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'drmarchands_library', 'library', 'DrMarchand Library', 'DrMarchands_Library', NULL, 'drmarchands_laboratory', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'creative_canvas', 'creative_workspace', 'Creative Canvas', NULL, NULL, 'drmarchands_laboratory', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'github_bridge_interface', 'bridge_interface', 'GitHub Bridge Interface', NULL, NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'google_drive_bridge_interface', 'bridge_interface', 'Google Drive Bridge Interface', NULL, NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'gemini_bridge_interface', 'bridge_interface', 'Gemini Bridge Interface', NULL, NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'hubspot_bridge_interface', 'bridge_interface', 'HubSpot Bridge Interface', NULL, NULL, 'creative_canvas', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'pandadoc_bridge_interface', 'bridge_interface', 'PandaDoc Bridge Interface', NULL, NULL, 'creative_canvas', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'discord_bridge_interface', 'bridge_interface', 'Discord Bridge Interface', NULL, NULL, 'creative_canvas', 'DrMarchand Laboratory', 'planned'),
(UUID(), 'bookshelf_database', 'database', 'BOOKSHELF', 'BOOKSHELF', NULL, 'drmarchands_library', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'library_database', 'database', 'LIBRARY', 'LIBRARY', NULL, 'drmarchands_library', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'mms_database', 'database', 'MMS', 'MMS', NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'cloud_database', 'database', 'CLOUD', 'CLOUD', NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'design_orchard_llc_database', 'database', 'DESIGN_ORCHARD_LLC', 'DESIGN_ORCHARD_LLC', NULL, 'design_orchard_llc', 'Design Orchard LLC', 'observed'),
(UUID(), 'neuro_forge_engine_database', 'database', 'Neuro-Forge_Engine', 'Neuro-Forge_Engine', NULL, 'neuro_forge_engine', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'hosting_designorchard_net', 'infrastructure_asset', 'designorchard.net cPanel Hosting', 'Neuro-Forge_Engine', 'infrastructure_assets', 'design_orchard_ecosystem', 'Design Orchard LLC', 'observed'),
(UUID(), 'hosting_kejstudio_com', 'infrastructure_asset', 'kejstudio.com cPanel Hosting', 'Neuro-Forge_Engine', 'infrastructure_assets', 'creative_canvas', 'Design Orchard LLC', 'observed'),
(UUID(), 'github_repo_drmarchand_os', 'repository', 'GitHub Repository: DrMarchand/DrMarchand-OS', NULL, NULL, 'drmarchand_os', 'DrMarchand Laboratory', 'observed'),
(UUID(), 'google_drive_pressure_test_layer', 'documentation_bridge', 'Google Drive Documentation and Pressure-Test Bridge', NULL, NULL, 'drmarchand_os', 'DrMarchand Laboratory', 'observed')
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
WHERE s.node_key = 'design_orchard_ecosystem' AND t.node_key = 'drmarchands_laboratory'
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'contains', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchands_laboratory' AND t.node_key IN ('drmarchand_os','drmarchands_library','creative_canvas')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'contains', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'drmarchand_os' AND t.node_key IN ('neuro_forge_engine','uni','github_repo_drmarchand_os','google_drive_pressure_test_layer')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'contains', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'neuro_forge_engine' AND t.node_key IN ('atlas','flywheel','workbench','bookshelf_database','library_database','mms_database','cloud_database','neuro_forge_engine_database')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'supports', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'uni' AND t.node_key IN ('atlas','flywheel','workbench','neuro_forge_engine')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'indexes', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'atlas' AND t.node_key IN ('bookshelf_database','library_database','mms_database','cloud_database','design_orchard_llc_database','neuro_forge_engine_database','hosting_designorchard_net','hosting_kejstudio_com')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'connects_to_external_service', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'neuro_forge_engine' AND t.node_key IN ('github_bridge_interface','google_drive_bridge_interface','gemini_bridge_interface','discord_bridge_interface')
ON DUPLICATE KEY UPDATE status = VALUES(status), weight = VALUES(weight);

INSERT INTO atlas_edges
(edge_uuid, source_node_uuid, target_node_uuid, relationship_type, direction, weight, status)
SELECT UUID(), s.node_uuid, t.node_uuid, 'connects_to_external_service', 'outbound', 1.00, 'active'
FROM atlas_nodes s JOIN atlas_nodes t
WHERE s.node_key = 'creative_canvas' AND t.node_key IN ('hubspot_bridge_interface','pandadoc_bridge_interface','discord_bridge_interface')
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
('binding_atlas_to_infrastructure_assets', 'atlas', 'infrastructure_assets', 'indexes', 'Atlas indexes infrastructure assets used by the Neuro-Forge Engine.', 'active'),
('binding_atlas_to_google_drive_evidence', 'atlas', 'google_drive_pressure_test_layer', 'documents', 'Atlas nodes are supported by Google Drive folder and milestone evidence.', 'active'),
('binding_atlas_to_github_registry', 'atlas', 'github_repo_drmarchand_os', 'documents', 'Atlas nodes are documented and versioned through the GitHub registry.', 'active'),
('binding_uni_to_atlas', 'uni', 'atlas', 'supports', 'UNI provides gear logic that lets Atlas function inside the engine.', 'active'),
('binding_creative_canvas_to_hubspot', 'creative_canvas', 'hubspot_bridge_interface', 'bridge_interface', 'Creative Canvas routes CRM operations through HubSpot bridge interface.', 'planned'),
('binding_creative_canvas_to_pandadoc', 'creative_canvas', 'pandadoc_bridge_interface', 'bridge_interface', 'Creative Canvas routes proposal and contract operations through PandaDoc bridge interface.', 'planned'),
('binding_creative_canvas_to_discord', 'creative_canvas', 'discord_bridge_interface', 'bridge_interface', 'Creative Canvas and engine notifications route through Discord bridge interface.', 'planned')
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
('hosting_designorchard_net', 'infrastructure_asset', 'observed', 'manual_cpanel_screenshot', 'cPanel hosting metadata recorded. Password excluded.'),
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
