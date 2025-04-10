#!/bin/bash
BASHRC="~/.bashrc"
GOPATH="/usr/local/bin/golang"
FORCE="0"

while [[ "$#" -gt '0' ]]; do
    case "$1" in
    '--gz')
        GZ="$2";shift;;
    '-d' | '--directory' | '--folder')
        DIRECTORY="$2";shift;;
    '--dl')
        DL="$2";shift;;
    '-f' | '--force')
        FORCE="1";;
    '-a' | '--all')
        BASHRC="/etc/bash.bashrc";;
    esac
    shift
done

MACHINE="$(uname -m)"
case "${MACHINE}" in
    'x86_64')
        ARCH="amd64";;
    'aarch64')
        ARCH="arm64";;
esac

if [ -z ${ARCH} ]; then
    echo "The architecture(${MACHINE}) is not supported."
    exit 1
fi

if ! [[ "${DL}" =~ ^https:\/\/.*\/$ ]]; then
    DL="https://go.dev/dl/"
fi

if [ -z ${DIRECTORY} ]; then
    DIRECTORY="/usr/local/share"
fi

if ! [[ "${GZ}" =~ ^go[[:digit:]]+[[:digit:]\.]+\.linux-${ARCH}\.tar\.gz$ ]]; then
    GZ=$(curl -s "${DL}" | sed -n '/\/dl\/go.*\.linux-'"${ARCH}"'\.tar\.gz/{p;q}' | sed -r 's/^<a[^>]+href="\/dl\/([^"]+)">$/\1/')
fi

GOROOT="${DIRECTORY}/go"
if [ -d ${GOROOT} ]; then
    if [ "${FORCE}" == "1" ]; then
        echo "Remove '${GOROOT}'"
        rm -rf "${GOROOT}"
    else
        echo "The directory '${GOROOT}' already exists."
        echo "Use '-f' or '--force' to remove it."
        exit 1
    fi   
fi

URL="${DL}${GZ}"

if [ ! -f ${GZ} ]; then
    echo "Download '${GZ}' FROM '${URL}'"
    curl --location --output "${GZ}" "${URL}"
fi

if [ ! -f ${GZ} ]; then
    echo "File '${GZ}' not found"
    exit 1
fi

echo "Extract '${GZ}' to '${GOROOT}'"
mkdir ${GOROOT}
tar -zxf ${GZ} --directory=${DIRECTORY}
if [ -f ${GZ} ]; then
    rm "${GZ}"
fi

if [[ -f "${GOROOT}/bin/go" ]]; then
    echo "Installed '$("${GOROOT}/bin/go" version)' at '${GOROOT}/bin/go'"    
fi

if [[ -f "${BASHRC}" ]]; then
    # GOROOT
    echo "Update \$GOROOT:'${GOROOT}' in '${BASHRC}'"
    sed -i "/^export GOROOT=.*$/d" ${BASHRC}
    sed -i "$ a export GOROOT=${GOROOT}" ${BASHRC}
    sed -i "/^export PATH=\$PATH:\$GOROOT\/bin$/d" ${BASHRC}
    sed -i "$ a export PATH=\$PATH:\$GOROOT\/bin" ${BASHRC}
    # GOPATH
    echo "Update \$GOPATH:'${GOPATH}' in '${BASHRC}'"
    sed -i "/^export GOPATH=.*$/d" "${BASHRC}"
    sed -i "$ a export GOPATH=${GOPATH}" ${BASHRC}
    sed -i "/^export PATH=\$PATH:\$GOPATH\/bin$/d" ${BASHRC}
    sed -i "$ a export PATH=\$PATH:\$GOPATH\/bin" ${BASHRC}
    echo "Please Use 'source ${BASHRC}' to refresh"
fi

exit 0