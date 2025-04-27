{pkgs, ...} @ inputs: [
  (import ./scripts/plan inputs)
  (import ./scripts/apply inputs)
  pkgs.opentofu
]
