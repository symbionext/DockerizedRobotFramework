# Dockerize a RobotFramework

Main focus of this project is to get Robot Framework http://robotframework.org/ , needed libraryes https://github.com/robotframework , Jenkins-slave tools https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin and RIDE https://github.com/robotframework/RIDE to be dockerized.<br>
Long time focus is get official Robot Framework base image to docker hub https://hub.docker.com/explore/ and based tools/libraryes & development images to Robot Framework base image (more info in "Enhancements to existing implementation"). 
Contributing of this project should follow guidlines that are defined in here https://github.com/docker-library/official-images

# Benefits of Robot Framework container 
* Easy installation just <b>docker run -P -d robot_framework</b>
* Container include: a) IDE and execution tools b) Libraryes c) Jenkins slave tools => No any more version conflicts between development/testing pipeline
* Easy to scale multiple instances by using docker micro servers => Papot library https://github.com/mkorpela/pabot change sequentally test cases execution to parallel execution that brings many huge benefits to picture (e.g. poor man performance testing and speed up of testing pipelines)
* Get test automation container integrated to Jenkins by using dynamicly way with https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin

# Container deploy time usage:
Define user to SSH connection: <b>-e SSHUSER=< username ></b>
<br><b><i>Basic auth:</b></i> Define user password to SSHUSER: <b>-e SSHUSERPW=< password ></b>
<br><b><i>OR Key based auth:</b></i> Define user public key to SSHUSER: <b>-e SSHUSERKEY="ssh-rsa < public key >"</b>

# Add more libraries to container:
* Base your docker file to robot framework container <i>FROM robotframework</i>
* Add required libraryes to your docker file by using any method what you want (e.g. pip, easyinstall, apt-get, etc.)
* Define your docker file entrypoint as <i>ENTRYPOINT ["/rfw_df_entrypoint.sh"]</i>

# Test cases development inside of container:
Use e.g. volume mount to get test cases from desktop git checkout to inside of TA-container.
<br>
<b>Get GUI open to desktop</b> (In linux xauth package is required to desktop):
* Get X-server to desktop machine (In windows https://sourceforge.net/projects/xming/ is ok).
* Activate X11 forwarding in SSH connection from desktop to container (In windows http://www.putty.org/ is ok).
<br>
<br>OR in linux world
<br>
<br>  docker run -ti --rm \
<br>      <b>-e DISPLAY=$DISPLAY \ </b>
<br>      <b>-v /tmp/.X11-unix:/tmp/.X11-unix \ </b>
<br>      < TA_container_image >

# Enhancements to existing implementation:
Split existing content to different images:
* <b>robot_framework_base</b> container that include Robot Framework, installed by using pip 
* <b>rf_jenkins_slave</b> container, based to robot_framework_base and include needed tools: https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin => This just bring ssh server and jre to container.
* <b>rf_exectools</b> customer specifig library container that based to rf_jenkins_slave container and customer required libraries are installed by using pip => This container is under execution in pipeline. It is light waith container to customer purposes. In here also papot could be installed by using pip.
* <b>rf_tests_development</b> test suites/cases development container. Based to rf_exectools container and RIDE is installed by using pip => This made possible test case development by using exactly same version of robot/libraryes than is used in pipeline.
<br>
<br>Endpoint of containers: endpoint to every container could be https://github.com/symbionext/DockerizedRobotFramework/blob/master/rfw_df_entrypoint.sh
<br>Benefit: Minimize content of containers. Just usage purpose guided stuff included to containers. Other benefits are same than before.

# INFO:
* Daylight of idea released in http://www.cs.tut.fi/tapahtumat/testaus16/
* Slides "Scalable Test Automation with Docker http://www.cs.tut.fi/tapahtumat/testaus16/kalvot/TTY-Sakari_Hoisko_TestingDay2016-Scalable_Test_Automation_with_Docker.pdf
* Demo Video "Scalable Test Automation with Docker" https://youtu.be/2nQ-xng4m4w
* Fellow behind of idea https://www.linkedin.com/in/sakarihoisko

# License:
<br>Copyright 2016 sakari.hoisko@symbio.com
<br>Copyright 2016 miyo@eficode.com
<br>
<br>Licensed under the Apache License, Version 2.0 (the "License");
<br>you may not use this file except in compliance with the License.
<br>You may obtain a copy of the License at
<br>
<br>http://www.apache.org/licenses/LICENSE-2.0
<br>
<br>Unless required by applicable law or agreed to in writing, software
<br>distributed under the License is distributed on an "AS IS" BASIS,
<br>WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
<br>See the License for the specific language governing permissions and
<br>limitations under the License.
