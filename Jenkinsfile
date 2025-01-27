pipeline {
agent { label 'dara-node' }


environment {
        AWS_ACCOUNT_ID="148338820041"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="uat"
        IMAGE_TAG="v1"
        REPOSITORY_URI = "148338820041.dkr.ecr.ap-south-1.amazonaws.com/uat"
        branch1 = "auth"
        branch2 = "transactional"
        branch3 = "cache"
      
    }


stages{
  stage('Checkout'){
    steps{
       echo 'git clone'
       git branch: 'main',
       credentialsId: '919c1894-7bc7-4bb8-9254-96c115e66cbb',
       changelog: false,
      url: 'https://github.com/daradevik/uat-all.git'
    }
   }

    stage('Stage-One') {
      steps {
        script {
                env.BRANCHDEPLOY = input message: 'User input required',
                ok: 'Deploy!',
                parameters: [choice(name: 'Branch to deploy', choices: "${branch1}\n${branch2}\n${branch3}", description: 'What branch you wont deploy?')]
        }
      }
    }
 stage('S3download')
        {
            steps {
                script{
                   sh 'aws s3 sync s3://odinbinaries-63moons/UAT/config/ . '
                   sh 'aws s3 cp s3://odinbinaries-63moons/UAT/services/${BRANCHDEPLOY}node .'
                }}
            }

 stage('Build'){
   steps{
   echo 'building docker images'
   script {
          sh """ sed -i -e 's/auth/${BRANCHDEPLOY}/g' Dockerfile """
          dockerImage = docker.build "${IMAGE_REPO_NAME}${BRANCHDEPLOY}:${IMAGE_TAG}"
        }
   }
   }
  stage('Logging into AWS ECR') {
      steps {
                script {
                sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS  --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }

            }
        }

 stage('Pushing to ECR') {
     steps{
         script {
               sh """docker tag ${IMAGE_REPO_NAME}${BRANCHDEPLOY}:${IMAGE_TAG} ${REPOSITORY_URI}/${BRANCHDEPLOY}:$IMAGE_TAG"""
               sh """docker push  ${REPOSITORY_URI}/${BRANCHDEPLOY}:$IMAGE_TAG"""
         }
        }
     }


  
 stage('Run') {
            steps {
                sh 'docker stop $(docker ps -a -q)'
                sh 'docker rm $(docker ps -a -q)'
                sh 'docker run -d -p 80:9701 --name ${IMAGE_REPO_NAME}  "${IMAGE_REPO_NAME}:${IMAGE_TAG}"'
            }
        }



}}

