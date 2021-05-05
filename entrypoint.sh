#!/bin/sh

set -e
set -x

if [ -z "$INPUT_APP_NAME" ]
then
  echo "App name must be defined"
  return -1
fi
INPUT_SOURCE_FILE="$INPUT_APP_NAME.txt"

if [ -z "$INPUT_SHOULD_INCREASE_VERSION" ]
then
  INPUT_SHOULD_INCREASE_VERSION=true
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=master
fi
OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH"

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@github.com/$INPUT_VERSIONS_REPO.git" "$CLONE_DIR"

cd "$CLONE_DIR"

VERSION=1
if [[ -f "$INPUT_SOURCE_FILE" ]]; then
  OLD_VERSION=$(cat "$INPUT_SOURCE_FILE")
  if [ "$INPUT_SHOULD_INCREASE_VERSION" = true ]; then
    VERSION=$(( OLD_VERSION + 1 ))
  else 
    VERSION="$OLD_VERSION"
  fi
fi

echo "$VERSION" > "$INPUT_SOURCE_FILE"

if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="Increased build number of $INPUT_APP_NAME: $VERSION"
fi

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing git commit"
  git push -u origin HEAD:$OUTPUT_BRANCH
else
  echo "No changes detected"
fi

echo "::set-output name=build_number::$VERSION"