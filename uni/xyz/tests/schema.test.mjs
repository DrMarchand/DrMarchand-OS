import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import Ajv2020 from "ajv/dist/2020.js";
import addFormats from "ajv-formats";

import { buildValidationObject } from "./helpers.mjs";

const schema = JSON.parse(await readFile(new URL("../schema/uni_xyz.schema.json", import.meta.url), "utf8"));
const ajv = new Ajv2020({ allErrors: true, strict: true, strictTypes: false });
addFormats(ajv);
const validate = ajv.compile(schema);

function errors() {
  return JSON.stringify(validate.errors, null, 2);
}

test("validation object passes the executable-law schema", () => {
  const object = buildValidationObject();
  assert.equal(validate(object), true, errors());
});

test("denied authority plus authorized mutation is rejected", () => {
  const object = buildValidationObject();
  object.command.authority_status = "DENIED";
  object.cycle.delta.authorized = true;
  object.cycle.delta.mutation_applied = true;
  object.cycle.delta.next_state_id = "state:forbidden";
  assert.equal(validate(object), false);
});

test("authorized reaction without effect receipt is rejected", () => {
  const object = buildValidationObject();
  object.cycle.delta.effect_receipt_id = null;
  assert.equal(validate(object), false);
});

test("classification inconsistent with expected and observed is rejected", () => {
  const object = buildValidationObject();
  object.observation.classification = "STABILITY_OR_INERT";
  assert.equal(validate(object), false);
});

test("completed cycle without BREATHE.OUT is rejected", () => {
  const object = buildValidationObject();
  object.cycle.breathe = object.cycle.breathe.filter((item) => item.direction === "IN");
  assert.equal(validate(object), false);
});

test("label-only phase without measurements is rejected", () => {
  const object = buildValidationObject();
  object.phase = { classification: "SOLID" };
  assert.equal(validate(object), false);
});

test("APPROVED without authority receipt or passing promotion gates is rejected", () => {
  const object = buildValidationObject({ lifecycle_status: "APPROVED" });
  assert.equal(validate(object), false);
});
