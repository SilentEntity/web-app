node('Environment'){
    stage('Checkout'){
        deleteDir()
        sh 'git clone https://github.com/SilentEntity/web-app.git'
    }
    stage('SonarQube Analysis') {
        withSonarQubeEnv('sonar') { 
          sh "cd web-app;mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.6.0.1398:sonar"
        }
    }
    stage("Quality Gate Check"){
        timeout(time: 1, unit: 'MINUTES') {
            def check = waitForQualityGate()
            if (check.status != 'OK') {
                mail bcc: '', 
                body: '''Hi \nQuality Gate Failure \nLink: '''+env.BUILD_URL,
                    cc: '', from: 'jenkins@local', replyTo: '', subject: 'Quilty gate Failure', to: 'silententity@example.com'
                error "Pipeline aborted due to quality gate failure: ${check.status}"
            }
        }
    }
    try{
        stage('Compile-Package'){ 
            sh "cd web-app;mvn clean package"
            archiveArtifacts '**/*.war'
        }
    }
    catch(all){
        mail bcc: '', 
            body: '''Hi \nBuild Failure \nLink: '''+env.BUILD_URL,
            cc: '', from: 'jenkins@local', replyTo: '', subject: 'BUILD Failure', to: 'silententity@example.com'
        error "Pipeline aborted due to BUILD Failure"
    }
    stage('Upload Artifact'){
        def server = Artifactory.server 'Artifactory-ID'
        def uploadSpec = """{
          "files": [
            {
              "pattern": "**/*app*.war",
              "target": "<repo key>/webApp-files/"
            }
         ]
        }""" 
        def buildInfo = server.upload spec: uploadSpec, failNoOp: true
        server.publishBuildInfo buildInfo
    }
}