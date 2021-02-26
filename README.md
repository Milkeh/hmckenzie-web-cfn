# hmckenzie.net CloudFormation Stack

**Note**: This stack was created for the purpose of my own personal portfolio website.

While there are customisable parameters, I have set the default and flexibility to match my own personal needs.

## Requirements
- S3 Bucket
  - A bucket containing the static web content
  - Another bucket to store the CodePipeline artifacts
- Your own domain hosted in Route 53
- Certificate in ACM or IAM for the above domain/hostname
- A Key Pair in the region this is being deployed in
- A connection to have been manually created to your repo in CodePipeline 


## Parameters
### IAM
- WebBucket - Bucket containing static media content
- CodePipelineBucket - Artifact bucket
- CodePipelineAccessPolicy (default) - CodePipeline Access Policy

### Compute
- NetworkStackName - The name given to the CloudFormation network stack
- CertificateARN - ARN of the ACM certificate to be used on the ALB
- AMI - The AMI ID of the AMI used for the ASG (Default to Amazon Linux in Ireland)
- KeyName - The Key Pair to be used on the EC2 instance

###  DNS
- HostedZoneID - The Hosted Zone ID for the domain being hosted in Route 53
- HostName - The hostname to be used for the frontend

###  CodePipeline
- ConnectionArn - The ARN of the pre-existing connection to GitHub

#### Diagram
![hmckenzie-net-cfn-diagram](https://hmckenzie-public.s3-eu-west-1.amazonaws.com/media/hmckenzie-net-cfn-diagram.jpg)