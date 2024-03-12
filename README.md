# Data Terms of Use Reaoner
- - - - - -

Uses EYE reasoner. Encoded as N3 -- both the policy, and the rules. Uses Notation 3 for expressing first-order formula.

## Usage

The followig files are the core reasoner implementations:

- `dtou-lang-reasoning.n3`: The axioms for DToU language reasoning (conformance checking, etc)

To perform reasoning, load the above files together with the policy set (and your query). We have provided example policy sets and queries:

- `dtou-policy-*.ttl`: The example policies
- `dtou-query.n3`: Example queries inherited from testing