<h3>Project Notes:</h3>

1. Use **Terraform** to configure AWS, ceate 3 instanes in 1 VPC

2. Use **Ansible** to config and conect these 3 instance.

   2.1 In 'ansible' instance: use ansible to set connection with 'jenkins_master' and 'jenkins_slave' instance

   2.2 In 'ansible' instance: config java & jenkins in 'jenkins_master'

   2.3 In 'ansible' instance: config maven in 'jenkins_slave' (jenkins still not found in 'jenkins_slave' now)

3. Access **Jenkins** page ('jenkins-master'instance public ip:8080),

   Add Global Credentials & 'jenkins-slave'(or called 'maven-slave')node

   there should be a jenkins folder in 'jenkins-slave' now

4. Write initial **jenkinfile**

5. Configure in Jenkins page:

   Connect **Github** with Credentials

   Add Github webhook for auto-trigger pipeline

   Setup Multibranch for this project

6. write **Dockerfile**

7. In Jenkinsfile, setup stage for BUILD IMAGE & PUSH IMAGE

   push image to **Docker Hub**: setup credential 'docker-hub-reop' (with docker hub username & password)

Done!

In 'jenkins_slave': docker run -dt -p 8000:8000 <dockerimageid>

    browser: jenkins_slave public ip:8000 open web page

---

8.  Use **Kubernetes**

configure **eks and eks-sg** with vpc

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

    9.3 Download Kubernetes credentials and cluster configuration (.kube/config file) from the cluster (update local **kubeconfig** file, with Kubernetes credentials and cluster configuration, so can interact with aws eks)

        aws eks update-kubeconfig --region ap-southeast-2 --name dop-eks-1

Done! Kubernetes set up.

10. In 'jenkins_slave', create /kubernetes

move deployment.yaml, namespace.yaml, service.yaml inside the folder

Note::: In deployment.yaml: pull image from docker hub need secret: </br>

    kubectl create secret docker-registry dop-token \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=<your-docker-username> \
    --docker-password=<your-docker-password OR token> \
    --docker-email=<your-email> \
    -n dop-namespace

If the above '--docker-password' use token：need to generate a token in docker hub account -> security </br>

Check To Confirm:

    kubectl get secrets -n dop-namespace

11. Create a script to apply: </br>

        kubectl apply -f namespace.yaml

        kubectl apply -f deployment.yaml

        kubectl apply -f service.yaml

In jenkinsfile: add a stage to use the script </br>

Check To Confirm:

    kubectl get pods -n dop-namespace

12. In AWS instance (worker node) -> security group add inbound 30082 </br>
    browser: worker node public ip:30082 open web page

Done!

---

13. Add **Prometheus** to monitor the kubernetes

    13.1 Install Helm:

        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

        chmod 700 get_helm.sh

        ./get_helm.sh

        helm version

    13.2 Create a namespace for Prometheus

        kubectl create namespace monitoring

    13.3 Add Prometheus Helm repo:

        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

        helm repo update

        helm repo list (check installed)

    13.4 Install Prometheus via Helm:

        helm install dop-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

        kubectl get pods（check installed）

    13.5 Access **Grafana** dashboard:

            kubectl get all -n monitoring

        (can see all service are internal with ClusterIP)

        Change the 'CluterIp' to 'LoadBalancer' for external access:

            kubectl edit svc prometheus-grafana -n monitoring

        browser: elb DNS name (no port needed) to access Grafana webpage

        LOGIN:

        username: admin

        password: prom-operator

    In dashboard, can see the monitoring data of ns, pod, etc.

Done!

(change back with ClusterIP: kubectl edit svc prometheus-grafana -n monitoring,

AWS LoadBalancer will be deleted)
