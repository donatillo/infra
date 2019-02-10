#!/bin/sh

if [ ! -f "secrets.auto.tfvars" ]; then
    echo "Please create a file called 'secrets.auto.tfvars' with the following format:"
    echo "-----------------------"
    echo "access_key = \"MY_AWS_ACCESS_KEY\""
    echo "secret_key = \"MY_AWS_SECRET_KEY\""
    echo "domain     = \"MY_DOMAIN\""
    echo "basename   = \"MY_APP\'S_BASE_NAME\""
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

echo '#'
echo '# destroying backend...'
echo '#'
echo
cd backend
rm -rf .terraform
terraform init
terraform destroy
cd ..

# vim:st=4:sts=4:sw=4:expandtab
