#!/usr/bin/env bash
# Build Path: /app/.heroku/php/
# Build Deps: php-5.5.30

OUT_PREFIX=$1

# fail hard
set -o pipefail
# fail harder
set -eux

DEFAULT_VERSION="1.7.22"
dep_version=${VERSION:-$DEFAULT_VERSION}
dep_dirname=swoole-${dep_version}
dep_archive_name=${dep_dirname}-stable.tar.gz
dep_url=https://github.com/swoole/swoole-src/archive/${dep_archive_name}

echo "-----> Building ext/swoole ${dep_version}..."

curl -L ${dep_url} | tar xz

pushd swoole-src-${dep_dirname}-stable

export PATH=${OUT_PREFIX}/bin:${PATH}
phpize
./configure     --prefix=${OUT_PREFIX}
make -s -j 9
# php was a build dep, and it's in $OUT_PREFIX. nuke that, then make install so all we're left with is the extension
#rm -rf ${OUT_PREFIX}/*
make install -s
popd

echo "-----> Done."
