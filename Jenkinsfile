pipeline {
agent { label 'dara-node' }


environment {
        AWS_ACCOUNT_ID="148338820041"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="uat-${BRANCHDEPLOY}"
        IMAGE_TAG="v1"
        REPOSITORY_URI = "148338820041.dkr.ecr.ap-south-1.amazonaws.com/uat/uat-auth"
        branch1 = "auth"
        branch2 = "tran"
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
            }}}

