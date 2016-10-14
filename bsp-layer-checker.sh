#!/bin/bash
# (c) 2016 Jan-Simon Möller (dl9pf@gmx.de>

if $(echo "$@" | grep -q -- '-d'); then
  set -x
fi 

usage() {
    echo "Usage: $0 meta-bsplayer [options]"
    echo "       Options:"
#    echo "                 -i - interactive (default)"
#    echo "                 -n - non-interactive"
#    echo "                 -q - quiet"
    echo "                 -d - debug"
}

printstep() {
        echo -n "Running step: $step ... "
}

good_or_exit() {
    if test x"1" = x"$res"; then
        echo "FAILED!"
        echo ""
        exit 1
    else
        echo "done."
    fi
}

test_cmd() {
    printstep
    $($cmd)
    res=$?
    good_or_exit
}

check_exists() {
    step="Check layer folder"
    cmd="test -d $LAYER"
    test_cmd

    step="Check conf/machine folder"
    cmd="test -d $LAYER/conf/machine"
    test_cmd

    step="Check _no_ conf/distro folder exists"
    cmd="test ! -d $LAYER/conf/distro"
    test_cmd
}

check_layerconf() {
    step="Check BBPATH is extended"
    cmd="grep -q BBPATH $LAYER/conf/layer.conf"
    test_cmd

    step="Check additions to BBFILES"
    cmd="grep -q BBFILES $LAYER/conf/layer.conf | grep -q bb"
    test_cmd

    step="Check presence of BBFILE_COLLECTIONS"
    cmd="grep -q BBFILE_COLLECTIONS $LAYER/conf/layer.conf"
    test_cmd

    step="Check presence of BBFILE_PATTERN_"
    cmd="grep -q BBFILE_PATTERN_ $LAYER/conf/layer.conf"
    test_cmd

    step="Check presence of BBFILE_PRIORITY_ $LAYER/conf/layer.conf"
    cmd="grep -q BBFILE_PRIORITY_ $LAYER/conf/layer.conf"
    test_cmd
}

check_preferred_kernel() {
    step="Check for PREFERRED_PROVIDER_virtual/kernel"
    cmd="grep -q -rn PREFERRED_PROVIDER_virtual/kernel ./$LAYER "
    test_cmd
}

check_preferred_bootloader() {
    step="Check for PREFERRED_PROVIDER_virtual/bootloader"
    cmd="grep -q -rn PREFERRED_PROVIDER_virtual/bootloader ./$LAYER"
    test_cmd

}
check_readme() {
    step="Check for README or README.md"
    cmd="test -f ./$LAYER/README -o ./$LAYER/README.md"
    test_cmd
}

check_build_oe_without() {
    :
}

check_build_oe_with_layer() {
    :
}

############### MAIN ################

if test x"" = x"$1" ; then
    usage
    exit 1
fi

LAYER=$1

check_exists
check_layerconf
check_preferred_kernel
check_preferred_bootloader
check_readme
