# CodeCommit to S3 Sync

AWS CodePipeline doesn't have an integration with AWS CodeCommit as of Oct 20, 2015.

This docker image requires two ENV variables.

```REPO``` and ```BUCKET```.

repo is the codecommit repo which is something like

    https://git-codecommit.us-east-1.amazonaws.com/v1/repos/helloawsworld.com

bucket is something like

    helloawsworldsource

run docker like

    docker run -e REPO=https://git-codecommit.us-east-1.amazonaws.com/v1/repos/helloawsworld.com -e BUCKET=helloawsworldsource cloudwayio/aws-codecommit-s3

## source
[https://github.com/cloudwayio/aws-codecommit-s3](https://github.com/cloudwayio/aws-codecommit-s3)