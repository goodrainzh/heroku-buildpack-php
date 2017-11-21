#!/usr/bin/env bash
# Build Path: /app/.heroku/php/
# Build Deps: php-7.0.4


# 扩展的安装路径
OUT_PREFIX=$1

# fail hard
set -o pipefail
# fail harder
set -eux

# php7对应的最新稳定版本
DEFAULT_VERSION="4.0.10"
dep_version=${VERSION:-$DEFAULT_VERSION}
dep_dirname=apcu-${dep_version}
dep_archive_name=${dep_dirname}.tgz
dep_url=http://pecl.php.net/get/${dep_archive_name}

echo "-----> Building ext/apcu ${dep_version}..."

curl -L ${dep_url} | tar xz

echo "-----> Building apcu download and decompress success"

pushd ${dep_dirname}
export PATH=${OUT_PREFIX}/bin:${PATH}
phpize
./configure \
    --prefix=${OUT_PREFIX} \
    --enable-apcu

echo "-----> Building configure success"

make -s -j 9
make install -s
popd

echo "-----> Done."