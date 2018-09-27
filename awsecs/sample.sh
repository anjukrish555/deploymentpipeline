aws ec2 create-security-group --group-name ECSSecurityGroup --description "ECSSecurityGroup"
aws ec2 authorize-security-group-ingress --group-name ECSSecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name ECSSecurityGroup --protocol tcp --port 8080 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name ECSSecurityGroup --protocol tcp --port 8081 --cidr 0.0.0.0/0
read -p 'Enter the security group Id for ECSSecurityGroup: ' secgroup
read -p 'Enter the Subnet Id: ' subnetid
echo >> "{
  "containerDefinitions": [
    {
      "name": "dockertask1",
      "image": "anjanakr/verse_gapminder:firsttry",
          "portMappings": [{
                      "containerPort": 8080,
                      "hostPort": 8080
              }],
      "memoryReservation": 300,
     "essential": true
    }
  ],
  "family": "dockertask1",
  "requiresCompatibilities": [
                        "EC2"
                  ],
                  "networkMode": "bridge"
}" >> task1.json
echo >> "First Task Created"
echo >> "{
  "containerDefinitions": [
    {
      "name": "dockertask2",
      "image": "anjanakr/verse_gapminder:firsttry",
          "portMappings": [{
                      "containerPort": 8080,
                      "hostPort": 8081
              }],
      "memoryReservation": 300,
     "essential": true
    }
  ],
  "family": "dockertask2",
  "requiresCompatibilities": [
                        "EC2"
                  ],
                  "networkMode": "bridge"
}" >> task2.json
echo >> "Second Task Created"
aws ecs register-task-definition --cli-input-json file://task1.json
echo >> "Task1 Registered" 
aws ecs register-task-definition --cli-input-json file://task2.json
echo >> "Task2 Registered" 
echo >> "#!/bin/bash
echo CLUSTER=docker >> /etc/ecs/ecs.config" >> clusterscript
echo >> "clusterscript created"
aws ec2 run-instances --image-id ami-5253c32d --count 1 --instance-type t2.micro --key-name devops --security-group-ids $secgroup --subnet-id $subnetid --iam-instance-profile Name="ecsInstanceRole" --user-data file://clusterscript
echo >> "EC2 created and associated with cluster"
aws ecs run-task --cluster default --task-definition dockertask1
echo >> "Task1 creation in progress"
aws ecs run-task --cluster default --task-definition dockertask2
echo >> "Task2 creation in progress"
echo >> "Check port 8080 and 8081 of the EC2 ip address"




