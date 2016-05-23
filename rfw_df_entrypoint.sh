#!/bin/bash
if [ "${SSHUSER}x" != "x" ] && [ ! -d /home/${SSHUSER} ];
then
	echo "INFO: add user:${SSHUSER} to container"
	useradd -m -d /home/${SSHUSER} -s /bin/bash -U ${SSHUSER}
	if [ "${SSHUSERKEY}x" != "x" ];
	then
		echo "INFO: Set user:${SSHUSER} public key to container"
		mkdir -pv /home/${SSHUSER}/.ssh
		chown ${SSHUSER}:${SSHUSER} /home/${SSHUSER}/.ssh
		chmod 700 /home/${SSHUSER}/.ssh
		echo ${SSHUSERKEY} ${SSHUSER}@public.key >> /home/${SSHUSER}/.ssh/authorized_keys
		chown ${SSHUSER}:${SSHUSER} /home/${SSHUSER}/.ssh/authorized_keys
		chmod 700 /home/${SSHUSER}/.ssh
		echo "INFO: Drop SSHUSERKEY env variable from container"
		unset SSHUSERKEY
	elif [ "${SSHUSERPW}x" != "x" ];
	then
		echo "INFO: Set user:${SSHUSER} password to container"
		echo "${SSHUSER}:${SSHUSERPW}" | chpasswd
		echo "INFO: Drop SSHUSERPW env variable from container"
		unset SSHUSERPW
	else
		echo "INFO: Set user:${SSHUSER} passwork / public key are not set to container"
		echo "INFO: YOU CAN NOT LOGIN TO CONTAINER BY SSH"
	fi
	echo "INFO: Drop SSHUSER env variable from container"
	unset SSHUSER
fi
/usr/sbin/sshd -D
