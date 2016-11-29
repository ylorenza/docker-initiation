#!/bin/bash
CWD=$(cd $(dirname $0);pwd)

function usage {
    echo "Usage: $0 <start ou stop ou plan> ";exit 1
}

if [ $# -lt 1 ];then
    usage
fi

ACTION=$1

case $ACTION in
    plan)
        terraform plan
    ;;
    start)
        terraform apply
    ;;
    stop)

        terraform destroy
    ;;
    *)
        usage
    ;;
esac
