# **Final Project KH032**

This project shows using CI/CD process. Here are two pipelines for devopses' team and developers' team. The idea of devopses' pipeline is ability to manage project's infrastructure from one repository. Also, developers' pipeline lets to manage application from one repository.
***

### DevOpses' Pipeline


DevOpses' Pipeline creates infrastructure for developers CI/CD pipeline [FinalDemoKHo32-app](https://github.com/TDSmaug/FinalDemoKHo32-app).
It starts from creating Jenkins instance by Terraform.
It described in :
[main.tf](https://github.com/TDSmaug/FinalDemoKHo32/blob/jenkins-instance/main.tf)

To create pipeline we need Jenkins.
Also we need that Jenkins could work with  tf-files, so it needs Terraform.
For automation issues both of them we put into the image and run as a docker container. All this process (with docker installation) described in [jenkins.sh](https://github.com/TDSmaug/FinalDemoKHo32/blob/jenkins-instance/jenkins.sh).

#### Jenkins Setup

After the instance was created and the docker container started, we install the necessary plugins.
In addition to the standard set, we use suggested plugins, plus next ones:
 - docker-step-build
 - Google Kubernetes Engine
 - Google Container Registry Auth Plugin
 - OAuth Credentials plugin

#### Adding bucket

We need that anyone can run Terraform in the pipeline. For this purpose we use Terraform backend that allows us to store and share state-file in remote bucket.
At first we create a Google Cloud Storage bucket:

![](http://joxi.net/n2YoZ8DIbxoLZr.png)

Than we define backend in *main.tf*  
Also, we have one more bucket for jenkins instance.

#### Jenkinsfile

In jenkins we describe our pipeline by [Jenkinsfile](https://github.com/TDSmaug/FinalDemoKHo32/blob/master/Jenkinsfile).
At the beginning we define environment variables in the environment section, and calling the credentials function to get the value of the terraform-auth secret we set in jenkins earlier.

![](http://joxi.net/E2pxBvot7Z9d42.png)

Then we’re ready to define the stages of our pipeline.
In stage 'Checkout' Jenkins clearing workspace and checking out *git repo* into it. Then base64 decodes the secret that we set as an environment variable. Thus workspace has json file just like our local directory.

![](http://joxi.net/a2XoKVpIwb1x6m.png)

In stage 'TF Plan' we perform our Terraform planning, in exactly the same way we can do in our local environment.

![](http://joxi.net/vAWoLD0IgWgjZA.png)

Stage 'Approval' pauses the pipeline and waits for the approval of a human operator before continuing. It gives a chance to check the output of terraform plan before applying it.

![](http://joxi.net/L21OXLyCR4R6zr.png)

![](http://joxi.net/DmBjzXpcJbJwMm.png)

Finally, stage 'TF Apply' applies terraform plan that was previously created, and we clean workspace in the end

![](http://joxi.net/Drl3banTVPVVvA.png)

#### Adding Job in Jenkins

***
##### DevOps Pipeline (devopses job)
This job pulls tf-files from this *repo* and creates a GKE cluster
In the Jenkins UI we create Pipeline item and telling Jenkins that it can find the Pipeline in a *repo* by selecting 'Pipeline script from SCM':

![](http://joxi.net/zANoa08IvDvjDr.png)

Also we adjust build trigger to start our job automatically by pull request in *ops repo*

![](http://joxi.net/L21OXLyCR4Rzbr.png)

On GitHub side:

![](http://joxi.net/Q2KoLnEILjLy62.png)

***

##### NameSpaces (ns job)

After cluster is builded we start new job to create two namespaces for each environment that described in developers CI/CD pipelines:
 - STAGE
 - PROD

![](http://joxi.net/v298XQZtZ6Z4zm.png)

***

##### STAGE (app job)
This Job automatically takes changes from [dev repo](https://github.com/TDSmaug/FinalDemoKHo32-app) 'development' branch and deploys it in created by *DevOps Pipeline* GKE cluster in 'STAGE' namespace. Also, we create required yaml file via Execute shell. Then we build image from [Dockerfile](https://github.com/TDSmaug/FinalDemoKHo32-app/blob/master/Dockerfile) and push it to our Google Container Registry. And, we deploy our app to the GKE.

![](http://joxi.net/bmoX0opH3K3QN2.png)

![](http://joxi.net/8AnnpXvHzlzwlA.png)

![](http://joxi.net/gmvNbRoiqXqN8m.png)



We adjust build trigger to start our job automatically by pull request in [dev repo](https://github.com/TDSmaug/FinalDemoKHo32-app).

***

##### PROD (app-prod job)
This Job automatically takes changes from [dev repo](https://github.com/TDSmaug/FinalDemoKHo32-app) 'master' branch and deploys it in created by *DevOps Pipeline* GKE cluster in 'PROD' namespace, and do the same:

![](http://joxi.net/YmEo9VEIwEwaxA.png)

![](http://joxi.net/eAOoRqVI9Y9bpA.png)

![](http://joxi.net/V2Vodn1Id3deQA.png)

We adjust build trigger to start our job automatically by pull request in [dev repo](https://github.com/TDSmaug/FinalDemoKHo32-app).
