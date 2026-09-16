export function submitCommand(commandGateway, command) {
  if (typeof commandGateway !== "function") throw new Error("A command gateway is required");
  return commandGateway(structuredClone(command));
}

export function renderGovernedState(state) {
  return Object.freeze({
    objectId: state.object_id,
    authority: structuredClone(state.authority),
    semanticBehavior: structuredClone(state.semantic_behavior),
    directMutationAllowed: false
  });
}
