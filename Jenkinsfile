

pipeline {
    agent any
    stages {
        
        stage('Run Tests') {
				parallel {
								stage('Unit Test') {
								agent any
								steps {
								
				           
									echo 'Unit testing...'
								}
								}
								stage('Regression Test') {
								agent any
								steps {
									echo 'Regression testing...'
									build job: 'UnitTest', wait: true
								}
								}
						}
				}
        stage('Approval') {
            // no agent, so executors are not used up when waiting for approvals
            
            steps {
					mail to: 'manisha.i.sharma@capgemini.com', 
					subject: "Please approve Jenkins Build UnitTest : ${env.JOB_NAME}: #${env.BUILD_NUMBER}", 
		body: """
		Unit_Test Job : ${currentBuild.currentResult} 
		Current Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n 
		More info at: ${env.BUILD_URL} 

		*******************************************************
		Please approve Unit_Test build at ${env.BUILD_URL}input/
		*******************************************************
		"""

					script{	
					def deploymentDelay = input id: 'Deploy', message: 'Deploy to production?', submitter: 'userId', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
										sleep time: deploymentDelay.toInteger(), unit: 'HOURS'
					}
            }
        }
        stage('Deploy') {
            
            steps {
                // uses https://plugins.jenkins.io/lockable-resources
                lock(resource: 'deployy'){
                    echo 'Deploying...'
					build job: 'Deployy', wait: true
                }
            }
        }
    }
}