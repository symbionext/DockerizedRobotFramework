#!/bin/bash
DockerizedRobotFramework_folder="/home/user/docker_stuff/DockerizedRobotFramework"
RobotFrameworkIMG="robotframework_img"
test -e ~/.ssh/id_rsa.pub && PublicSSHKey="$(cat ~/.ssh/id_rsa.pub)"
VOLUME_FROM="${DockerizedRobotFramework_folder}/demo"

case $1 in
	start)
		docker run -d -p 22220:22 -P -e SSHUSER=pabotmaster -e SSHUSERKEY="${PublicSSHKey}" -v ${VOLUME_FROM}:/demo --name=ta_master $RobotFrameworkIMG
		docker run -d -p 22221:22 -e SSHUSER=pabot1 -e SSHUSERPW=pabot1pw -v ${VOLUME_FROM}:/demo --name=ta_1 $RobotFrameworkIMG
		docker run -d -p 22222:22 -e SSHUSER=pabot2 -e SSHUSERPW=pabot2pw -v ${VOLUME_FROM}:/demo --name=ta_2 $RobotFrameworkIMG
		docker run -d -p 22223:22 -e SSHUSER=pabot3 -e SSHUSERPW=pabot3pw -v ${VOLUME_FROM}:/demo --name=ta_3 $RobotFrameworkIMG
	;;
	stop)
		docker stop ta_master ta_1 ta_2 ta_3
		docker rm ta_master ta_1 ta_2 ta_3
	;;
	build)
		CURRENT_FOLDER=$(pwd)
		cd ${DockerizedRobotFramework_folder};
		docker build -f robot_framework_dockerfile -t "${RobotFrameworkIMG}" . 
		cd ${CURRENT_FOLDER};
	;;
	sshrunpabot)
		echo "NOTE: some stdout error in end not exist when you really log in by manually and call pabot by manually in SSH window"
		ssh -q -X pabotmaster@localhost -p 22220 "pabot --pabotlib --processes 10 --resourcefile /demo/TA_cluster.dat /demo/pabot_eg"
	;;
	sshrunpybot)
		ssh -q -X pabotmaster@localhost -p 22220 "pybot /demo/pabot_eg"
	;;
	runpabot)
		echo "NOTE: stdout error in end should not exist"
		pabot --pabotlib --processes 10 --resourcefile /demo/TA_cluster.dat /demo/pabot_eg
	;;
	runpybot)
		pybot /demo/pabot_eg
	;;
	logtomaster)
		ssh -X pabotmaster@localhost -p 22220
	;;
esac
