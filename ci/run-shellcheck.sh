#!/usr/bin/env bash

error=0

while IFS= read -r script; do
    echo "${script}"
    shellcheck --color -x "${script}" || error=1
done < <(git ls-files | grep -E '^hw[0-9]+/.*\.sh$')

exit $error
