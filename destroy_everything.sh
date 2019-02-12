#!/bin/sh

set -x
set -e

if [ "$#" -ne 4 ]; then
  echo "Usage $0 BASENAME GIT_USER GIT_PASSWORD BRANCH"
  exit 1
fi

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

read -r -p "Are you sure you want to destroy the whole infrastructure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        exit 0
        ;;
esac

rm -rf backend-aws-java
rm -rf front-aws-react
rm -rf jenkins-aws

echo '#'
echo '# destroying backend'
echo '#'
echo
git clone https://$2:$3@github.com/give-and-take/backend-aws-java.git
cd backend-aws-java
git checkout $4
cd terraform
./init.sh $1
cp ../../secrets.auto.tfvars .
terraform destroy -auto-approve -var env=$4
cd ..
rm -rf backend-aws-java
echo

echo '#'
echo '# destroying frontend'
echo '#'
echo
git clone https://$2:$3@github.com/give-and-take/frontend-aws-react.git
cd frontend-aws-react
git checkout $4
cd terraform
./init.sh $1
cp ../../secrets.auto.tfvars .
terraform destroy -auto-approve -var env=$4
cd ..
rm -rf frontend-aws-react
echo

echo '#'
echo '# destroying jenkins'
echo '#'
echo
git clone https://$2:$3@github.com/give-and-take/jenkins-aws.git
cd jenkins-aws/terraform
./init.sh $1
cp ../../secrets.auto.tfvars .
terraform destroy -auto-approve
cd ..
rm -rf jenkins-aws
echo

echo '#'
echo '# destroying common infrastructure...'
echo '#'
echo
cd common
rm -rf .terraform
BUCKET=$(grep basename secrets.auto.tfvars | sed -e 's/basename\s*=\s"\(.*\)"/\1/g')-terraform
echo "Setting up bucket ${BUCKET}"
terraform init -backend-config="bucket=${BUCKET}"
terraform destroy -auto-approve
cd ..

echo '#'
echo '# destroying backend...'
echo '#'
echo
cd backend
rm -rf .terraform
terraform init
terraform destroy -auto-approve
cd ..

# vim:st=4:sts=4:sw=4:expandtab
