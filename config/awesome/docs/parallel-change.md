Guideline: Work with "Parallel Change" (Expand and Contract) by Martin Fowler

Never modify a critical function in place. Instead, create a new implementation that conforms to the same interface or contract.

Introduce the new code alongside the old one. Keep both active until the new one is proven.

When writing code, prefer indirection. For example, introduce an abstraction layer (e.g., a wrapper, factory, or feature flag) that can delegate calls to either the old or the new implementation.

Keep call sites stable. Do not update every function call immediately—let the routing abstraction decide.

Test both implementations in parallel. Route a subset of calls, compare outputs, and measure performance.

Migrate gradually. Once confident, update references to use the new code. Only remove the old implementation after all usage is gone and the system is verified.

Accept temporary duplication. Duplication is allowed during the transition—it’s safer than premature generalization.

Example workflow:

Step 1: Wrap the existing function in an interface.

Step 2: Add a new implementation class/function adhering to that interface.

Step 3: Update the wrapper to delegate to either version (configurable).

Step 4: Write tests and run both versions in parallel.

Step 5: Migrate callers once the new version is validated.

Step 6: Remove the old version only after full migration.
