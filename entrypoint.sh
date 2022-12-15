#!/bin/bash
istrue () {
  case $1 in
    "true"|"yes"|"y") return 0;;
    *) return 1;;
  esac
}

set -e

# Go to GitHub workspace.
if [ -n "$GITHUB_WORKSPACE" ]; then
  cd "$GITHUB_WORKSPACE" || exit
fi

# Set repository from GitHub, if not set.
if [ -z "$INPUT_REPO" ]; then INPUT_REPO="$GITHUB_REPOSITORY"; fi
# Set user input from repository, if not set.
if [ -z "$INPUT_USER" ]; then INPUT_USER=$(echo "$INPUT_REPO" | cut -d / -f 1 ); fi
# Set project input from repository, if not set.
if [ -z "$INPUT_PROJECT" ]; then INPUT_PROJECT=$(echo "$INPUT_REPO" | cut -d / -f 2- ); fi


# Only show last tag.
if istrue "$INPUT_ONLYLASTTAG"; then
  INPUT_DUETAG=""
  INPUT_SINCETAG=$(git describe --abbrev=0 --tags $(git rev-list --tags --skip=1 --max-count=1))
fi

# Build arguments.
if [ -n "$INPUT_USER" ]; then ARG_USER="--user $INPUT_USER"; fi
if [ -n "$INPUT_PROJECT" ]; then ARG_PROJECT="--project $INPUT_PROJECT"; fi
if [ -n "$INPUT_TOKEN" ]; then ARG_TOKEN="--token $INPUT_TOKEN"; fi
if [ -n "$INPUT_DATEFORMAT" ]; then ARG_DATEFORMAT="--date-format $INPUT_DATEFORMAT"; fi
if [ -n "$INPUT_OUTPUT" ]; then ARG_OUTPUT="--output $INPUT_OUTPUT"; fi
if [ -n "$INPUT_BASE" ]; then ARG_BASE="--base $INPUT_BASE"; fi
if [ -n "$INPUT_HEADERLABEL" ]; then ARG_HEADERLABEL=(--header-label "$INPUT_HEADERLABEL"); fi
if [ -n "$INPUT_CONFIGURESECTIONS" ]; then ARG_CONFIGURESECTIONS=(--configure-sections "$INPUT_CONFIGURESECTIONS"); fi
if [ -n "$INPUT_ADDSECTIONS" ]; then ARG_ADDSECTIONS=(--add-sections "$INPUT_ADDSECTIONS"); fi
if [[ -n $INPUT_AUTHOR ]]; then if istrue "$INPUT_AUTHOR"; then ARG_AUTHOR="--author"; else ARG_AUTHOR="--no-author"; fi; fi
if [[ -n $INPUT_COMPARELINK ]]; then if istrue "$INPUT_COMPARELINK"; then ARG_COMPARELINK="--compare-link"; else ARG_COMPARELINK="--no-compare-link"; fi; fi
if [ -n "$INPUT_EXCLUDETAGS" ]; then ARG_EXCLUDETAGS=(--exclude-tags "$INPUT_EXCLUDETAGS"); fi
if [ -n "$INPUT_EXCLUDETAGSREGEX" ]; then ARG_EXCLUDETAGSREGEX=(--exclude-tags-regex "$INPUT_EXCLUDETAGSREGEX"); fi
if [ -n "$INPUT_SINCETAG" ]; then ARG_SINCETAG="--since-tag $INPUT_SINCETAG"; fi
if [ -n "$INPUT_DUETAG" ]; then ARG_DUETAG="--due-tag $INPUT_DUETAG"; fi
if [ -n "$INPUT_RELEASEURL" ]; then ARG_RELEASEURL="--release-url $INPUT_RELEASEURL"; fi
if [[ -n $INPUT_VERBOSE ]]; then if istrue "$INPUT_VERBOSE"; then ARG_VERBOSE="--verbose"; else ARG_VERBOSE="--no-verbose"; fi; fi

# Generate change log.
# shellcheck disable=SC2086 # We specifically want to allow word splitting.
github_changelog_generator \
  $ARG_USER \
  $ARG_PROJECT \
  $ARG_TOKEN \
  $ARG_DATEFORMAT \
  $ARG_OUTPUT \
  $ARG_BASE \
  "${ARG_HEADERLABEL[@]}" \
  "${ARG_CONFIGURESECTIONS[@]}" \
  "${ARG_ADDSECTIONS[@]}" \
  $ARG_AUTHOR \
  $ARG_COMPARELINK \
  "${ARG_EXCLUDETAGS[@]}" \
  "${ARG_EXCLUDETAGSREGEX[@]}" \
  $ARG_SINCETAG \
  $ARG_DUETAG \
  $ARG_RELEASEURL \
  $ARG_VERBOSE

# Locate change log.
FILE="CHANGELOG.md"
if [ -n "$INPUT_OUTPUT" ]; then FILE="$INPUT_OUTPUT"; fi

# Strip Markdown headers.
if istrue "$INPUT_STRIPHEADERS"; then
  echo "Stripping headers."
  sed -i '/^#/d' "$FILE"
fi

# Strip generator notice.
if istrue "$INPUT_STRIPGENERATORNOTICE"; then
  echo "Stripping generator notice."
  sed -i '/This Changelog was automatically generated/d' "$FILE"
fi

# Save change log to outputs.
if [[ -e "$FILE" ]]; then
  CONTENT=$(cat "$FILE")
  # Escape as per https://github.community/t/set-output-truncates-multiline-strings/16852/3.
  CONTENT="${CONTENT//'%'/'%25'}"
  CONTENT="${CONTENT//$'\n'/'%0A'}"
  CONTENT="${CONTENT//$'\r'/'%0D'}"
  echo ::set-output name=changelog::"$CONTENT"
fi
