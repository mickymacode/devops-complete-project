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

6. write Dockerfile

7. In Jenkinsfile, setup stage for BUILD IMAGE & PUSH IMAGE

   push image to Docker Hub: setup credential 'docker-hub-reop' (with docker hub username & password)

Done!

In 'jenkins_slave': docker run -dt -p 8000:8000 <dockerimageid>

    browser: jenkins_slave public ip:8000 open web page

---

8.  configure eks and eks-sg with vpc

9.  Integrate 'jenkins_slave' with Kubernetes cluster just create

    9.1 In 'jenkins_slave': Setup kubectl:

        curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.9/2023-01-11/bin/linux/amd64/kubectl

        chmod +x ./kubectl

        sudo mv ./kubectl /usr/local/bin

        kubectl version --short

    9.2 In 'jenkins_slave': Setup awsctl:

        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

        unzip awscliv2.zip

        sudo ./aws/install --update

        Then connect to aws account:

        aws configure

        with access_key, secret_key

    9.3 Download Kubernetes credentials and cluster configuration (.kube/config file) from the cluster (update local kubeconfig file, with Kubernetes credentials and cluster configuration, so can interact with aws eks)

        aws eks update-kubeconfig --region ap-southeast-2 --name dop-eks-1

Done! Kubernetes set up.

10. In 'jenkins_slave', create /kubernetes

move deployment.yaml, namespace.yaml, service.yaml inside the folder

Note::: In deployment.yaml: pull image from docker hub need secret: </br>
kubectl create secret docker-registry dop-token \ </br>
--docker-server=https://index.docker.io/v1/ \ </br>
--docker-username=<your-docker-username> \ </br>
--docker-password=<your-docker-password OR token> \ </br>
--docker-email=<your-email> \ </br>
-n dop-namespace </br>

If password use token：need to generate a token in docker hub account -> security

11. Create a script to apply: </br>
    kubectl apply -f namespace.yaml </br>
    kubectl apply -f deployment.yaml </br>
    kubectl apply -f service.yaml </br>

In jenkinsfile: add a stage to use the script

12. In AWS instance (worker node) -> security group add inbound 30082 </br>
    browser: worker node public ip:30082 open web page
