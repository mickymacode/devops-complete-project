1. Use Terraform to configure AWS, ceate 3 instanes in 1 VPC
2. Use Ansible to config and conect these 3 instance. 
    2.1 In 'ansible' instance: use ansible to set connection with 'jenkins_master' and 'jenkins_slave' instance
    2.2 In 'ansible' instance: config java & jenkins in 'jenkins_master'
    2.3 In 'ansible' instance: config maven in 'jenkins_slave' (jenkins still not found in 'jenkins_slave' now)

3. Access Jenkins page ('jenkins-master'instance public ip:8080),
Add Global Credentials & 'jenkins-slave'(or called 'maven-slave')node
there should be a jenkins folder in 'jenkins-slave' now

4. Write initial jenkinfile
5. Configure in Jenkins page: 
    Connect Github with Credentials
    Add Github webhook for auto-trigger pipeline
    Setup Multibranch for this project

