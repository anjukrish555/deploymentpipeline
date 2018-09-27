apt-get install -y openjdk-8-jre > /dev/null 2>&1
apt-get install -y openjdk-8-jdk > /dev/null 2>&1
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add - > /dev/null 2>&1
sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"
apt-get update -y -qq
echo -e "-- Installing Jenkins automation server\n"
apt-get install jenkins -y -qq


