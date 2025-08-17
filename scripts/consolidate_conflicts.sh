#!/bin/bash
# consolidate_conflicts.sh

if [ $# -lt 2 ]; then
	echo "Usage: $0 master_file conflict_file1 [conflict_file2 ...]"
	exit 1
fi

master="$1"
shift

echo "Checking for unique lines in conflicted files..."
echo "Master file: $master"
echo

for conflict in "$@"; do
	echo "=== Analyzing $conflict ==="

	# Lines only in conflict file
	unique_lines=$(comm -23 <(sort "$conflict") <(sort "$master") | wc -l)

	if [ "$unique_lines" -gt 0 ]; then
		echo "⚠️  Found $unique_lines unique lines:"
		comm -23 <(sort "$conflict") <(sort "$master") | sed 's/^/  + /'
	else
		echo "✅ No unique lines found"
	fi
	echo
done
