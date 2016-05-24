#!/bin/bash
#Copyright 2016 Symbio
#sakari.hoisko@symbio.com
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

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
		echo "INFO: User:${SSHUSER} password / public key are not set to container"
		echo "INFO: YOU CAN NOT LOGIN TO CONTAINER BY SSH"
	fi
	echo "INFO: Drop SSHUSER env variable from container"
	unset SSHUSER
fi
/usr/sbin/sshd -D
