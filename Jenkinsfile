pipeline 
{
    agent { label 'builder' }
    environment
    {
        VERSION_NUMBER = '9.4.0.54424'
        IMAGE_VERSION = "${GIT_BRANCH == "master" ? VERSION_NUMBER : VERSION_NUMBER+"-"+GIT_BRANCH}"
        DOCKER_HUB = credentials("dockerhub-creds")
    }
    stages 
    {
        stage('build') { steps { script { sh("docker build -t nschultz/sonarqube:${IMAGE_VERSION} --build-arg SONAR_VERSION_ARG=${VERSION_NUMBER} .") } } }
        stage('push')
        { 
            steps
            {
                script 
                {
                    sh  """
                        #!/bin/bash
                        docker login -u ${DOCKER_HUB_USR} -p ${DOCKER_HUB_PSW}
                        docker push nschultz/sonarqube:${IMAGE_VERSION}
                        docker logout
                        """ 
                } 
            }
        }
    }
}