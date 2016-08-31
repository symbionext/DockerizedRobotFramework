#!/bin/bash
DockerizedRobotFramework_folder="~/docker_stuff/DockerizedRobotFramework"
RobotFrameworkIMG="saken_robo_img"
PublicSSHKey="$(cat ~/.ssh/id_rsa.pub)"
VOLUME_FROM="${DockerizedRobotFramework_folder}/demo"

case $1 in
	start)
		echo docker run -d -p 22220:22 -P -e \"SSHUSER=pabotmaster\" -e \"SSHUSERKEY=${PublicSSHKey}\" -v ${VOLUME_FROM}:/demo --name=ta_master $RobotFrameworkIMG
		echo docker run -d -p 22221:22 -e \"SSHUSER=pabot1\" -e "SSHUSERPW=pabot1pw" -v ${VOLUME_FROM}:/demo --name=ta_1 $RobotFrameworkIMG
		echo docker run -d -p 22222:22 -e \"SSHUSER=pabot2\" -e "SSHUSERPW=pabot2pw" -v ${VOLUME_FROM}:/demo --name=ta_2 $RobotFrameworkIMG
		echo docker run -d -p 22223:22 -e \"SSHUSER=pabot3\" -e "SSHUSERPW=pabot3pw" -v ${VOLUME_FROM}:/demo --name=ta_3 $RobotFrameworkIMG
	;;
	stop)
		docker stop ta_master ta_1 ta_2 ta_3
		docker rm ta_master ta_1 ta_2 ta_3
	;;
#	build)
#		cd ${DockerizedRobotFramework_folder}
#		docker build -f robot_framework_dockerfile -t ${RobotFrameworkIMG} . 
#		cd -
#	;;
	runpabot)
		pabot --pabotlib --processes 10 --resourcefile /demo/TA_cluster.dat /demo/pabot_eg
	;;
	runpybot)
		pybot /demo/papot_eg/
	;;
	logtomaster)
		ssh -X pabotmaster@localhost -p 22220
	;;
esac

