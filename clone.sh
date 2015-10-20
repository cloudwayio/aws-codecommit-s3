AWS_ROLE=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/`
ACCESS_KEY_ID=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$AWS_ROLE/|grep -i AccessKeyId|awk '{print $3}'| sed -n 's/\"\(.*\)\",/\1/p'`
SECRET_ACCESS_KEY=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$AWS_ROLE/|grep -i SecretAccessKey|awk '{print $3}'| sed -n 's/\"\(.*\)\",/\1/p'`

mkdir ~/.aws
echo > ~/.aws/credentials

cat <<EOF>> ~/.aws/credentials
[default]
ACCESS_KEY_ID = $ACCESS_KEY_ID
SECRET_ACCESS_KEY = $SECRET_ACCESS_KEY
EOF


git config --global credential.helper '!aws --profile default codecommit credential-helper $@'
git config --global credential.UseHttpPath true

echo "zipping $REPO as artifact.zip and uploading to $BUCKET"

mkdir ~/repo
cd ~/repo
rm -rf ~/repo/*
git clone $REPO
zip -r artifact.zip .
aws s3 cp  ~/repo/artifact.zip s3://$BUCKET/artifact.zip
