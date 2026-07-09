#!/usr/bin/env bash
#
# clean-caches.sh — remove Xcode / SwiftPM build caches for this project.
#
# By default cleans everything that is specific to THIS project and safely
# regenerable on the next build:
#   - repo-local Build/ (DerivedData for the in-repo build)
#   - Modules/<module>/.build and Modules/<module>/.swiftpm
#   - root-level .build (if present)
#   - fastlane test artifacts
#   - the project's global DerivedData (~/.../DerivedData/AgeVerification-*)
#
# Shared caches (used by ALL your Swift/Xcode projects) are only touched
# with --deep, since clearing them forces a full re-fetch/re-index for
# every other project too:
#   - ~/Library/Caches/org.swift.swiftpm         (SwiftPM dependency cache)
#   - ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex
#   - ~/Library/Caches/com.apple.dt.Xcode
#
# Usage:
#   scripts/clean-caches.sh            # project-specific caches
#   scripts/clean-caches.sh --deep     # also clear shared SwiftPM/Xcode caches
#   scripts/clean-caches.sh --dry-run  # show what would be removed, delete nothing
#   scripts/clean-caches.sh --help

set -euo pipefail

# --- args --------------------------------------------------------------------
DEEP=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --deep)    DEEP=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      sed -n '2,32p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown option: $arg (try --help)" >&2
      exit 1
      ;;
  esac
done

# --- locate repo root --------------------------------------------------------
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME="AgeVerification"

freed_total=0

# human_size <path> -> bytes (0 if missing)
size_bytes() {
  [ -e "$1" ] || { echo 0; return; }
  # -sk = KB, portable on macOS; convert to bytes
  local kb
  kb=$(du -sk "$1" 2>/dev/null | awk '{print $1}')
  echo $(( kb * 1024 ))
}

human() {
  local b=$1
  if   [ "$b" -ge 1073741824 ]; then awk "BEGIN{printf \"%.2f GB\", $b/1073741824}"
  elif [ "$b" -ge 1048576 ];    then awk "BEGIN{printf \"%.1f MB\", $b/1048576}"
  elif [ "$b" -ge 1024 ];       then awk "BEGIN{printf \"%.1f KB\", $b/1024}"
  else echo "${b} B"; fi
}

# remove <path> <label>
remove() {
  local path="$1" label="$2"
  if [ ! -e "$path" ]; then
    return
  fi
  local bytes
  bytes=$(size_bytes "$path")
  freed_total=$(( freed_total + bytes ))
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "  [dry-run] would remove %-40s %s\n" "$label" "$(human "$bytes")"
  else
    printf "  removing %-40s %s\n" "$label" "$(human "$bytes")"
    rm -rf "$path"
  fi
}

# remove_glob <label> <glob...>  — expands globs safely
remove_glob() {
  local label="$1"; shift
  local p
  for p in "$@"; do
    if [ -e "$p" ]; then
      remove "$p" "$label"
    fi
  done
}

echo "Cleaning caches for $PROJECT_NAME (repo: $REPO_ROOT)"
[ "$DRY_RUN" -eq 1 ] && echo "(dry run — nothing will be deleted)"
echo

# --- project-local artifacts -------------------------------------------------
echo "Project-local build artifacts:"
remove "$REPO_ROOT/Build"  "Build/"
remove "$REPO_ROOT/.build" ".build (root)"

# SwiftPM per-module caches
while IFS= read -r d; do
  remove "$d" "$(echo "$d" | sed "s#$REPO_ROOT/##")"
done < <(find "$REPO_ROOT/Modules" -maxdepth 2 -type d \( -name ".build" -o -name ".swiftpm" \) 2>/dev/null)

# fastlane artifacts
remove "$REPO_ROOT/fastlane/test_output" "fastlane/test_output"
remove_glob "fastlane report" "$REPO_ROOT/fastlane/report.xml" "$REPO_ROOT/fastlane/Preview.html"
echo

# --- project global DerivedData ----------------------------------------------
echo "Global DerivedData (this project only):"
remove_glob "DerivedData/$PROJECT_NAME-*" "$HOME/Library/Developer/Xcode/DerivedData/${PROJECT_NAME}-"*
echo

# --- shared caches (opt-in) --------------------------------------------------
if [ "$DEEP" -eq 1 ]; then
  echo "Shared caches (--deep; affects ALL Xcode/SwiftPM projects):"
  remove "$HOME/Library/Caches/org.swift.swiftpm" "SwiftPM cache"
  remove "$HOME/Library/Developer/Xcode/DerivedData/ModuleCache.noindex" "Xcode ModuleCache"
  remove "$HOME/Library/Caches/com.apple.dt.Xcode" "Xcode cache"
  echo
else
  echo "Skipping shared SwiftPM/Xcode caches (pass --deep to include them)."
  echo
fi

# --- summary -----------------------------------------------------------------
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Would free approximately: $(human "$freed_total")"
else
  echo "Freed approximately: $(human "$freed_total")"
fi
