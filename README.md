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

# Setting Up ECS Environment

## Setup ECS Clsuter

Follow the instructions [here](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted.html) to create ECS Cluster

## Create Task

Once you have ECS cluster up with an instance create a task definition.

- Go to **Task Definitions** page, select **Create new Task Definition**
- In the **Task Definition Name** field, enter a name for your task definition.
- Click **Add Container Definition** 
  - Give a name
  - Enter ```cloudwayio/aws-codecommit-s3``` as **Image**
- Click **Advanced container configuration**
  - Under **Env Variables**
  - Enter ```REPO``` as key and name of the CodeComit repo as value
  - Enter ```BUCKET``` as key and  bucket name as value

## Run task from cli

List task definitions

    $ aws ecs list-task-definitions --region us-east-1 

    {
	"taskDefinitionArns": [
	    "arn:aws:ecs:us-east-1:1234567890:task-definition/codecommit-test:1" 
	]
    }


Run the task

    $ aws ecs run-task --cluster default --count 1 --task-definition codecommit-test:1 --region us-east-1

    {
	"failures": [], 
	"tasks": [
	    {
		"taskArn": "arn:aws:ecs:us-east-1:1234567890:task/2e69330a-a688-4f66-b741-280a38c7a7ca", 
		"overrides": {
		    "containerOverrides": [
			{
			    "name": "codecommit-test"
			}
		    ]
		}, 
		"lastStatus": "PENDING", 
		"containerInstanceArn": "arn:aws:ecs:us-east-1:1234567890:container-instance/14a57c7c-5fa6-4836-bfcc-e7eb0454c6ee", 
		"clusterArn": "arn:aws:ecs:us-east-1:1234567890:cluster/default", 
		"desiredStatus": "RUNNING", 
		"taskDefinitionArn": "arn:aws:ecs:us-east-1:1234567890:task-definition/codecommit-test:1", 
		"containers": [
		    {
			"containerArn": "arn:aws:ecs:us-east-1:1234567890:container/7c4052cc-0ca7-48c6-bab4-e2ac421f461e", 
			"taskArn": "arn:aws:ecs:us-east-1:1234567890:task/2e69330a-a688-4f66-b741-280a38c7a7ca", 
			"lastStatus": "PENDING", 
			"name": "codecommit-test"
		    }
		]
	    }
	]
    }

    $ aws ecs list-tasks --region us-east-1 --cluster default
    {
	"taskArns": [
	    "arn:aws:ecs:us-east-1:1234567890:task/2e69330a-a688-4f66-b741-280a38c7a7ca"
	]
    }

## Check Bucket

After docker instance finishes running, you must have a new file named ```artifact.zip``` in the bucket you passed to the task.


## Note

EC2 Container Instance must have an EC2 Role which has access to the CodeCommit repository and S3 bucket.

## Reference
[Souce Code](https://github.com/cloudwayio/aws-codecommit-s3)

## Dockerhub
[Dockerhub](https://hub.docker.com/r/cloudwayio/aws-codecommit-s3/)