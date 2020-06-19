

pipeline {
    agent any
    stages {
        
		stage('Pull Changes') {
            
            steps {
                echo 'Starting Test Execution...'
				           
				build job: 'Detect_Changes', wait: true

            }
        }
		
		stage('Check Config') {
            
            steps {
                echo 'Checking configuration file....'
				           
				build job: 'Check_Config', wait: true

            }
        }
		
		stage('Build and Execute') {
            
            steps {
                echo 'Building and Executing modified code...'
				           
				build job: 'Build_n_Execute', wait: true

            }
        }
		
        stage('Test') {
            
            steps {
                echo 'Starting Test Execution...'
				           
				build job: 'Unit_Test', wait: true

            }
        }
        stage('Approval') {
            // no agent, so executors are not used up when waiting for approvals
            
            steps {
			
			echo "Sending mail for Test Approval..."
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
                lock(resource: 'Deploy'){
                    echo 'Deploying...'
					build job: 'Deploy', wait: true
                }
            }
        }
    }
}