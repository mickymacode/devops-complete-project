pipeline {
    agent {
        // the previous created node 'maven-slave', with the label 'maven'
        node {
            label 'maven'
        }
    }
    environment {
        //maven was not set in the system's PATH in jenkins_slave instance
        //set the path here so can use mvn
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH "
    }
    stages {
        stage('build') {
            steps {
                echo "building java-maven app here......"
                dir('jenkins/workspace/devops-complete-project_dev/java-app') {
                    sh 'mvn clean deploy -Dmvn.test.skip=true'
                }
            }
        }
        // stage('test') {
        //     steps {
        //         echo "testing java-maven app here......"
        //         sh 'mvn surefire-report:report'
        //     }
        // }
    }
}