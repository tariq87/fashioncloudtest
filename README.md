# fashioncloudtest

<h2>Install Terraform</h2>
https://www.terraform.io/downloads.html
<br><br>
Clone this repository and run the following commands

To Setup the Infrastructure<br>
<strong>terraform plan</strong><br>
<strong>terraform apply</strong>

To Destroy the infrastrucure<br>
<strong>terraform destroy</strong><br>
<p>================================</p>
<p><h2>Intial Setup</h2></p>
<p>Install AWS Cli
Run "aws configure" command to setup the credentials file.
Once you have your profile set , you can start using the above terraform commands to configure your infrastructure.
The terraform template creates a vpc, security groups, ec2 instances and an ELB.
The instances get registered to the ELB automatically and will take 60 seconds to come in service.
The key would be provided to access the EC2 instances.
</p>