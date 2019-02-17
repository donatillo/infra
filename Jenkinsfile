pipeline {

    agent any

    environment {
        CI = true
    }

    stages {

        stage('Plan infrastructure') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        sh """
                            cd terraform 
                            terraform init -backend-config='access_key=$USER' -backend-config='secret_key=$PASS' -backend-config='bucket=${env.MY_APP}-terraform'
                            terraform plan -no-color -out=tfplan -var \"access_key=$USER\" -var \"secret_key=$PASS\"
                        """
                        if (env.BRANCH_NAME == "master") {
                            timeout(time: 10, unit: 'MINUTES') {
                                input(id: "Deploy Gate", message: "Deploy application?", ok: 'Deploy')
                            }
                        }
                    }
                }
            }
        }

        stage('Apply infrastrcuture') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "cd terraform && terraform apply -no-color -lock=false -input=false tfplan"
                    sh "echo Add the user/pass credentials above to Jenkins with the id 'dynamo.'"
                }
            }
        }

    }
}

// vim:st=4:sts=4:sw=4:expandtab:syntax=groovy
