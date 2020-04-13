pipeline 
{
    agent any
    environment
    {
        VERSION_NUMBER = '0.1.0'
        IMAGE_VERSION = "${GIT_BRANCH == "master" ? VERSION_NUMBER : VERSION_NUMBER+"-"+GIT_BRANCH}"
        DOCKER_HUB = credentials("dockerhub-creds")
    }
    stages 
    {
        stage('build') { steps { script { sh("docker build -t nschultz/sonarqube:${IMAGE_VERSION} .") } } }
        stage('push')
        { 
            when { branch 'master' }
            steps
            {
                script 
                {
                    sh  """
                        #!/bin/bash
                        docker login -u ${DOCKER_HUB_USR} -p ${DOCKER_HUB_PSW}
                        docker push nschultz/sonarquabe:${IMAGE_VERSION}
                        docker logout
                        """ 
                } 
            }
        }
    }
}