pipeline {

  agent any
/*
We define environment variables in the environmentsection,
and calling the credentials function to get the value of the terraform-auth secret we set in jenkins earlier.
*/
  environment {
   SVC_ACCOUNT_KEY = credentials('terra-auth')
 }

  stages {
/*
Checking out git repo into its workspace.
Then base64 decodes the secret that we set as an environment variable.
Thus workspace has json file just like our local directory.
*/
      stage('Checkout') {
        steps {
          checkout scm
          sh 'echo $SVC_ACCOUNT_KEY | base64 -d > finaldemokh032-e628298ba948.json'
        }
      }
//Using Terraform planning to see changes
      stage('TF Plan') {
            steps {
                sh 'terraform init -no-color'
                sh 'terraform plan -no-color'
            }
            }
/*
This stage it pauses the pipeline and waits for the approval of a human operator before continuing.
It gives a chance to check the output of terraform plan before applying it.
*/
            stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        }
      }
    }
// Applying terraform plan that was previously created
            stage('TF Apply') {
      steps {
          sh 'terraform apply --auto-approve -no-color'
      }
    }
// Clearing Workspace
    stage('clean-ws') {
        steps {
          cleanWs()
        }
      }

}
}
