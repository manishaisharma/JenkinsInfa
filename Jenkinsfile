pipeline {
    agent any
	environment {
       FOLDER_NAME = "${params.Informatica_Folder}"
     }
	 parameters {
        string(name: 'Informatica_Environment', defaultValue: 'DEV', description: 'Please enter Informatica_Environment from values- DEV, QA, PROD')

        string(name: 'Informatica_Folder', defaultValue: 'SOURCE_F', description: 'Enter your working Source Folder in Informatica')
	
		string(name: 'Repository_Label_Query_Name', defaultValue: 'MODIFIED_OBJECTS', description: 'Enter your Repository Query Name to fetch your labeled and modified objects')
	
		string(name: 'Database_SID', defaultValue: '10.100.253.11', description: 'Enter Database Host')
		
		string(name: 'Database_Host', defaultValue: 'ORA12C', description: 'Enter Database SID')
		
		string(name: 'Database_PORT', defaultValue: '1521', description: 'Enter Database PORT')
		
		choice(name: 'GitStore', choices: ['https://github.com/manishaisharma/JenkinsInfa.git','https://github.com/manishaisharma/Inf_PC.git','https://github.com/manishaisharma/P_Center.git'], description: 'Pick your Git Repository')

    }
    stages {
        
		stage('Pull Changes') {
            
			
				steps{


				script{
				if (params.Informatica_Environment == "PROD") {
					orgLogin = "prod_db_repo"
					orgLogininfa = "prod_pc_login"
					
				} else if (params.Informatica_Environment == "QA") {
					orgLogin = "qa_db_repo"
					orgLogininfa = "qa_pc_login"
					
				} else if (params.Informatica_Environment == "DEV") {
					orgLogin = "dev_db_repo"
					orgLogininfa = "dev_pc_login"
					
				} else {
					orgLogin = "dev_db_repo"
					orgLogininfa = "dev_pc_login"
				   
				}
			
			  }
			    
				git url: params.GitStore, credentialsId: 'My_Git_Creds', branch: 'master'
			   
			
                echo 'Fetching changes from Informatica Repository...'
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${orgLogininfa}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
				sh "sh  ${WORKSPACE}/J_Informatica_Scripts/Infa_list_modified_objects.sh  ${username} ${password} ${WORKSPACE} ${params.Informatica_Folder} ${params.Repository_Label_Query_Name}"
				}
				

            }
        }
		
		stage('Check Config') {
            
            steps {
                echo 'Checking configuration file....'
				sh "sh  ${WORKSPACE}/J_Informatica_Scripts/Infa_check_config_of_modified_objects.sh ${WORKSPACE} "



            }
        }
		
		stage('Build') {
            
            steps {
                echo 'Building and Executing modified code...'
				

				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${orgLogininfa}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
				sh '''
								cat ${WORKSPACE}/List_of_Jobs_with_valid_config.txt | while read line
				do
				echo $line
				sh ${WORKSPACE}/J_Informatica_Scripts/Infa_connect_build_job.sh ${USERNAME} ${PASSWORD} ${WORKSPACE} "\${FOLDER_NAME}" $line
				done'''

				}

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
			echo "Deploying code..."
                // uses https://plugins.jenkins.io/lockable-resources
                lock(resource: 'Deploy'){
                    echo 'Deploying...'
					/*sh  "${WORKSPACE}/J_Informatica_Scripts/Infa_Create_Deployment_Group.sh ${username} ${password} ${WORKSPACE}"
					withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${orgLogininfa}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
					
					sh  "${WORKSPACE}/J_Informatica_Scripts/Infa_Deploy_Group_Objects.sh  ${username} ${password} ${WORKSPACE} ${params.Informatica_Folder} ${params.Repository_Label_Query_Name}"
					}
					*/
					
					build job: 'Deploy', wait: true
					
					
                }
            }
        }
    }
}