#!/usr/bin/env bash
# Build Path: /app/.heroku/php/
# Build Deps: php-5.5.11

OUT_PREFIX=$1

# fail hard
set -o pipefail
# fail harder
set -eux

DEFAULT_VERSION="1.2.3"
dep_version=${VERSION:-$DEFAULT_VERSION}
dep_dirname=oauth-${dep_version}
dep_archive_name=${dep_dirname}.tgz
dep_url=http://pecl.php.net/get/${dep_archive_name}

echo "-----> Building ext/oauth ${dep_version}..."

curl -L ${dep_url} | tar xz

pushd ${dep_dirname}
export PATH=${OUT_PREFIX}/bin:${PATH}
phpize
./configure \
    --prefix=${OUT_PREFIX} \
    --enable-oauth
make -s -j 9
# php was a build dep, and it's in $OUT_PREFIX. nuke that, then make install so all we're left with is the extension
#rm -rf ${OUT_PREFIX}/*
make install -s
popd

echo "-----> Done."
