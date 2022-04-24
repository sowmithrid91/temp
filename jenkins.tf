node {
    stage('terraform deployment'){
	sh "ls -lart"
	sh "sudo cp -R /home/lttsansible/terraform1/main.tf ."
	sh "pwd"
	sh "ls -lart"
    sh "terraform init"
	sh "terraform validate "
	sh "terraform plan -lock=false"
	sh "terraform apply -lock=false --auto-approve"
	//sh "terraform destroy -lock=false --auto-approve"
    }	
}
