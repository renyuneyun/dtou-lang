# Data Terms of Use Reaoner
- - - - - -

Uses EYE reasoner. Encoded as N3 -- both the policy, and the rules. Uses RDF Surfaces for expressing first-order formula.

## Usage

The followig files are the core reasoner implementations:

- `dtou-lang-general.n3s`: The general reasoning rules not specifically for DToU (e.g. `rdfs:subClassOf`)
- `dtou-lang.n3s`: The axioms for DToU language, but not for the reasoning (conformance checking, etc)
- `dtou-lang-reasoning.n3s`: The axioms for DToU reasoning

To perform reasoning, load the above files together with the policy set (and your query). We have provided example policy sets and queries:

- `dtou-policy-*.n3s`: The example policies
- `dtou.n3s`: Example queries inherited from testing

