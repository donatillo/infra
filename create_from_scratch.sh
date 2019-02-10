#!/bin/sh

set -e

if [ ! -f "secrets.auto.tfvars" ]; then
    echo "Please create a file called 'secrets.auto.tfvars' with the following format:"
    echo "-----------------------"
    echo "access_key = \"MY_AWS_ACCESS_KEY\""
    echo "secret_key = \"MY_AWS_SECRET_KEY\""
    echo "domain     = \"MY_DOMAIN\""
    echo "basename   = \"MY_APP\'S_BASE_NAME\""
    echo "region     = \"AWS_REGION\""
    echo "-----------------------"
    echo "Don't put this file under version control!"
    exit 1
fi

echo '#'
echo '# creating backend...'
echo '#'
echo
cd backend
terraform init
terraform apply "$@"
cd ..
echo

echo '#'
echo '# creating common infrastructure...'
echo '#'
echo
cd common
rm -rf .terraform
BUCKET=$(grep basename secrets.auto.tfvars | sed -e 's/basename\s*=\s"\(.*\)"/\1/g')-terraform
echo "Setting up bucket ${BUCKET}"
terraform init -backend-config="bucket=${BUCKET}"
terraform apply "$@"
cd ..
echo

echo 'Creation completed.'

# vim:st=4:sts=4:sw=4:expandtab
