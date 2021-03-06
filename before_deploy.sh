# This script takes care of building your crate and packaging it for release

set -ex

main() {
    local ROOT=$(pwd)
    local src=$(pwd)/svgcleaner \
          stage=

    case $TRAVIS_OS_NAME in
        linux)
            stage=$(mktemp -d)
            ;;
        osx)
            stage=$(mktemp -d -t tmp)
            ;;
    esac

    cd $src
    test -f Cargo.lock || cargo generate-lockfile

    cross rustc --bin svgcleaner --target $TARGET --release -- -C lto

    cp target/$TARGET/release/svgcleaner $stage/

    cd $stage
    tar czf $CRATE_NAME-$TRAVIS_TAG-$TARGET.tar.gz *
    cp *.tar.gz $ROOT
    echo "BEFORE_DEPLOY: DEBUG -- LOCATION"
    ls -la .
    ls -la $ROOT

    cd $src
    echo "BEFORE_DEPLOY: DONE"
    rm -rf $stage
}

main
