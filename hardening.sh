#!/bin/sh

banner() {
    echo "################################################################################"
    echo "#        Assessment of binaries from GTFOBins are present in this box          #"
    echo "#                       https://gtfobins.github.io/                            #"
    echo "################################################################################"
}

help() {
    echo "Usage: $0 <endpoint>"
}

binaries=`curl -s https://gtfobins.github.io/ | grep "bin-name" | awk -F '>' '{print $3}' | awk -F '<' '{print $1}'`
hostname=`hostname`
url=$1
exists=""
data=""

verify_binaries() {
    for i in ${binaries}; do
        command -v $i > /dev/null 2>&1 && exists="$exists $i"
    done
}

generate_json() {
    data="$data {\n\t\"hostname\": \""$hostname"\",\n\t\"binaries\": [\n"
    for item in ${exists}; do
        data="$data \t\t{\"name\": \"${item}\", \"link\": \"https://gtfobins.github.io/gtfobins/${item}/\"},\n"
    done
    data="$data \t]\n}"
}

send() {
  curl -X POST -H "Content-Type: application/json" -d "${data}" "your_server:your_port/rest_endpoint" 
}

banner

verify_binaries

generate_json

echo $data

# send