pipeline {

    agent any

    environment {
        CI = true
    }

    stages {

        stage('Plan resource groups') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        sh """
                            cd resourcegroup
                            terraform init -backend-config='access_key=$USER' -backend-config='secret_key=$PASS' -backend-config='bucket=${env.MY_APP}-terraform'
                            terraform plan -no-color -out=tfplan -var 'access_key=$USER' -var 'secret_key=$PASS'
                        """
                    }
                }
            }
        }

        stage('Plan network') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        sh """
                            cd network
                            terraform init -backend-config='access_key=$USER' -backend-config='secret_key=$PASS' -backend-config='bucket=${env.MY_APP}-terraform'
                            terraform plan -no-color -out=tfplan -var 'access_key=$USER' -var 'secret_key=$PASS' -var 'basename=${env.BASENAME}'
                        """
                    }
                }
            }
        }

        stage('Deploy changes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        if (env.BRANCH_NAME == "master") {
                            timeout(time: 10, unit: 'MINUTES') {
                                input(id: "Deploy Gate", message: "Deploy application?", ok: 'Deploy')
                            }
                        }
                        sh """
                            cd resourcegroup && terraform apply -no-color -lock=false -input=false tfplan && cd ..
                            cd network       && terraform apply -no-color -lock=false -input=false tfplan && cd ..
                        """
                    }
                }
            }
        }

        // sh "echo Add the user/pass credentials above to Jenkins with the id 'dynamo.'"

    }
}

// vim:st=4:sts=4:sw=4:expandtab:syntax=groovy
