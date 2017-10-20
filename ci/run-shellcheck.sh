#!/usr/bin/env bash

error=0

while IFS= read -r script; do
    echo "${script}"
    sed -i -E 's;#!(/usr/bin/env )?labshell;#!/usr/bin/env bash;' "${script}"
    shellcheck --color -x "${script}" || error=1
done < <(git ls-files | grep -E '\.(sh)$')

exit $error
