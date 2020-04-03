#!/bin/sh

curl -LOfsS https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 || {
  echo "Failed to download jq"
  exit 1
}

echo "Downloaded jq"

curl -OfsS https://raw.githubusercontent.com/stedolan/jq/master/sig/v1.6/jq-linux64.asc || {
  echo "Failed to download signature"
  exit 1
}

echo "Downloaded signature"

curl -OfsS https://raw.githubusercontent.com/stedolan/jq/master/sig/v1.6/sha256sum.txt || {
  echo "Failed to download checksum"
  exit 1
}

echo "Downloaded checksum"

curl -sS https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key | gpg --import 2>/dev/null || {
  echo "Failed import gpg key"
  exit 1
}

echo "Imported gpg key"

gpg --verify jq-linux64.asc 2>/dev/null || {
  echo "Failed to verify jq"
  exit 1
}

echo "Verified jq"

sha256sum -c --ignore-missing --quiet sha256sum.txt || {
  echo "Failed to verify jq checksum"
  exit 1
}

echo "Verified jq checksum"

ctr=$(buildah from docker.io/amazon/aws-cli:2.0.6)
mnt=$(buildah mount $ctr)

chmod +x jq-linux64

cp jq-linux64 $mnt/usr/local/bin/jq

buildah unmount $ctr

buildah config --entrypoint "" $ctr
buildah config --cmd "/bin/bash" $ctr

buildah commit $ctr test
