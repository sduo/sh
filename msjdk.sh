DEB="packages-microsoft-prod.deb"
URL="https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/${DEB}"

while [[ "$#" -gt '0' ]]; do
    case "$1" in
    '-v' | '--version')
        JDK="$2";shift;;    
    esac
    shift
done



if [ ! -f ${DEB} ]; then
    echo "Download '${DEB}' FROM '${URL}'"
    curl --location --output "${DEB}" "${URL}"
fi

if [ ! -f ${DEB} ]; then
    echo "File '${DEB}' not found"
    exit 1
fi

echo "DPKG install '${DEB}'"
dpkg --install "${DEB}"
if [ -f ${DEB} ]; then
    rm "${DEB}"
fi

echo "Update apt"
apt-get install apt-transport-https --yes --quiet
apt update --quiet

if [ -z "${JDK}" ]; then
    echo "Search Microsoft OpenJDK"
    JDK=$(apt-cache search 'msopenjdk-[[:digit:]]+' | sed -n '$p' | sed -r 's/^([^ ]+) .*$/\1/')
fi

if [ -z "${JDK}" ]; then
    echo "Available Microsoft OpenJDK"
    apt-cache search 'msopenjdk-[[:digit:]]+' | sed -r 's/^([^ ]+) .*$/\1/'
    exit 1
fi

echo "Install Microsoft OpenJDK '${JDK}'"
apt-get install "${JDK}" --yes

java --version

exit 0