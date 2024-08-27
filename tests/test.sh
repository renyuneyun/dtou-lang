#!/bin/bash

OUTPUT_TMP=tmp.ttl

#eye --quiet --nope --no-bnode-relabeling ../dtou-lang-reasoning.n3s ../dtou-lang-general.n3s ../dtou-lang.n3s dtou-policy-app-1.ttl dtou-policy-data-1.ttl --query query-output.n3 --output $OUTPUT_TMP
#eye --quiet --nope --no-bnode-relabeling ../dtou-lang-reasoning.n3s ../dtou-lang-general.n3s ../dtou-lang.n3s dtou-policy-app-1.ttl dtou-policy-data-1.ttl --pass-only-new
#eye --quiet --nope --no-bnode-relabeling ../dtou-lang-reasoning.n3 ../dtou-lang-general.n3s ../dtou-lang.n3s --query query-derived-policy.n3 --output $OUTPUT_TMP

eyeEntail() {
	f1=$1
	f2=$2
	out=`eye --quiet --nope $f1 --entail $f2`
	if [ "$out" = 'true.' ]; then
		return 0
	else
		return 1
	fi
}

runTest() {
	dataPol=$1
	appPol=$2
	query=$3
	correctResult=$4
	#eye --quiet --nope --blogic ../dtou-lang-reasoning.n3 ../dtou-lang-general.n3s ../dtou-lang.n3s $dataPol $appPol --query $query --output $OUTPUT_TMP  # N3; older version eye reasoner argument (e.g. v5.2.2)
	#eye --quiet --nope --blogic ../dtou-lang-reasoning.n3s ../dtou-lang-general.n3s ../dtou-lang.n3s $dataPol $appPol --query $query --output $OUTPUT_TMP  # RDF Surafaces; older version eye reasoner argument (e.g. v5.2.2)
	#eye --quiet --nope --no-bnode-relabeling ../dtou-lang-reasoning.n3 ../dtou-lang-general.n3s ../dtou-lang.n3s $dataPol $appPol --query $query --output $OUTPUT_TMP  # N3, with some RDF Surfaces not finished conversion; newer eye reasoner argument (e.g. 10.19.6)
	eye --quiet --nope ../dtou-lang-reasoning.n3 dtou-policy-vocabulary.ttl $dataPol $appPol --query $query --output $OUTPUT_TMP  # N3, with some RDF Surfaces not finished conversion; newer eye reasoner argument (e.g. 10.19.6)

	# rdf-diff $correctResult $OUTPUT_TMP
	# return $?

	exitCode=0
	eyeEntail $correctResult $OUTPUT_TMP 
	if [ $? -ne 0 ]; then
		printf "Output has extra. "
		let "exitCode = $exitCode + 1"
	fi
	eyeEntail $OUTPUT_TMP $correctResult
	if [ $? -ne 0 ]; then
		printf "Output has incomplete. "
		let "exitCode = $exitCode + 2"
	fi
	if [ $exitCode -gt 0 ]; then
		printf "\n"
	fi
	return $exitCode
}

wrap() {
	printf "%-40s: " "$1"
	# "${@:2}" > /dev/null && echo pass || echo fail
	"${@:2}" && echo pass
}


wrap "Only attribute propagation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-derived_policy-attribute.n3 correct-output_attribute-propagate-only.ttl
wrap "Only tag propagation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-derived_policy-tag.n3 correct-output_tag-propagate-only.ttl
wrap "Only prohibition propagation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-derived_policy-prohibition.n3 correct-output_prohibition-propagate-only.ttl
wrap "Only obligation propagation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-derived_policy-obligation.n3 correct-output_obligation-propagate-only.ttl
wrap "Full data policy propagation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-derived-policy.n3 correct-output_derived_propagate-only.ttl  # The "correct" output is only after a brief verification. Something is not correct with the definition (see commented-out lines in "correct" output)
wrap "Only attribute with refinement" runTest dtou-policy-data-1.ttl dtou-policy-app-1.ttl query-derived_policy-attribute.n3 correct_output-derived_policy-refinement-attribute.ttl  # The "correct" output is only after a brief verification. Something is not correct with the definition (see commented-out lines in "correct" output)
wrap "Only tag with refinement" runTest dtou-policy-data-1.ttl dtou-policy-app-1.ttl query-derived_policy-tag.n3 correct_output-derived_policy-refinement-tag.ttl  # The "correct" output is only after a brief verification. Something is not correct with the definition (see commented-out lines in "correct" output)
wrap "Full data policy with refinement" runTest dtou-policy-data-1.ttl dtou-policy-app-1.ttl query-derived-policy.n3 correct-output_derived-policy_refinement.ttl  # The "correct" output is only after a brief verification. Something is not correct with the definition (see commented-out lines in "correct" output)
wrap "Conflict" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-conflict.n3 correct-output_conflict.ttl
wrap "Activated Obligation" runTest dtou-policy-data-1.ttl dtou-policy-app_propagate-only.ttl query-obligation.n3 correct-output_obligation.ttl  # The "correct" output may not be correct; eye has some issues before v10.19.6 (#113)
