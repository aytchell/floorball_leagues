#!/bin/bash

if [ -z "$KEY_PASSWORD" ] || [ -z "$ALIAS_PASSWORD" ]; then
    echo "Error: password environment variable is not set";
    exit 1;
fi

# There is an upper limit for the integer representation of the build number
# So we can only take the 'ten minutes digit' and have to chop off the
# 'minutes digit'
pre_number=$(date +'%y%m%d%H%M')
build_number=${pre_number%?}

git_hash=$(git rev-parse --short HEAD)

echo "Building release package:"
echo "  - git hash is $git_hash"
echo "  - build number id $build_number"

flutter build appbundle                 \
    --dart-define git_hash=$git_hash    \
    --build-number $build_number        \
    --release
