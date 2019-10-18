#!/bin/bash
#
# ZBox setup
#
# Maintenance: REQUIRED
#
# Any file edited in this script with "sid" will 
# have a backup file with ".bak" extention.
#


#------------------------------ B A N N E R ------------------------------#

printf '
:::::::::  :::::::::    ::::::::   :::    :::
     :+:   :+:    :+:  :+:    :+:  :+:    :+: 
    +:+    +:+    +:+  +:+    +:+   +:+  +:+      
   +#+     +#++:++#+   +#+    +:+    +#++:+      ________________  _____
  +#+      +#+    +#+  +#+    +#+   +#+  +#+    / __/ __/_  __/ / / / _ \
 #+#       #+#    #+#  #+#    #+#  #+#    #+#  _\ \/ _/  / / / /_/ / ___/
#########  #########    ########   ###    ### /___/___/ /_/  \____/_/					                       
\n'

#-------------------------------------------------------------------------#


declare -A tools=(

	["VMWare"]="https://www.vmware.com/go/getplayer-linux"
	["GoLang"]="https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz"
	["NoMachine"]="https://download.nomachine.com/download/6.8/Linux/nomachine_6.8.1_1_amd64.deb"	
	["Kerbrute"]="github.com/ropnop/kerbrute"
	["Gowitness"]="github.com/sensepost/gowitness"
	["Impacket"]="https://github.com/SecureAuthCorp/impacket"
	["CrackMapExec"]="https://github.com/byt3bl33d3r/CrackMapExec"
	["SLUserNames"]="https://github.com/insidetrust/statistically-likely-usernames"
	["SecList"]="git clone https://github.com/danielmiessler/SecLists.git"
	["Nessus"]="https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/10092/download?i_agree_to_tenable_license_agreement=true"
	
)

#-------------------------------------------------------------------------------------------

declare -A yesORno=(

	["VMWare"]="Y"
	["NoMachine"]="Y"
	["Kerbrute"]="Y"
	["Gowitness"]="Y"
	["Impacket"]="Y"
	["CrackMapExec"]="Y"
	["SLUserNames"]="Y"
	["SecList"]="Y"
	["Nessus"]="Y"
	["Bettercap"]="Y"
	["Libreoffice"]="Y"
	["Heimdal_clients"]="Y"
	["Bloodhound"]="Y"
	["Nessus"]="Y"
	["test_case"]="N"
)

#-------------------------------------------------------------------------------------------

#Print Menu 

echo -e  "\t\t This Script Can installl Following Tools:"

for i in "${!yesORno[@]}"
do
	echo -e "\t\t${i}"
done
	
#-------------------------------------------------------------------------------------------

# Enable the ssh and edit 'sshd_config' file


	file_path='/etc/ssh/sshd_config'
	update-rc.d ssh enable
	sed -i.bak s/"#PermitRootLogin prohibit-password"/"PermitRootLogin yes"/ $file_path


#-------------------------------------------------------------------------------------------

# checkpoint whether going full install or manual 


	read -p "Do you want to go Manually [y] or Hail Mary [n]: (y/n) => " hardWay
	until [ $hardWay == "y" -o $hardWay == "Y" -o $hardWay == "n" -o $hardWay == "N" ]
	do
		echo "Invalid input try again"
  		read -p "Do you want to go Manually [y] or Hail Mary [n]: (y/n) => " hardWay
	done

	if [ "$hardWay" == "y" -o "$hardWay" == "Y" ] ; then
		for i in "${!yesORno[@]}"
		do	
			yORn=""
			read -p "${i} select it (y/n): " yORn
			until [ $yORn == "y" -o $yORn == "Y" -o $yORn == "n" -o $yORn == "N" ]
			do
				echo "Invalid input try again"
	  			read -p "${i} select it (y/n): " yORn
			done
		done
	 		yesORno[$i]=$yORn
	fi


#-------------------------------------------------------------------------------------------
# Miscellaneous 

# Animation function
buffer(){
	spinner=( "|" "/" "-" "\\" )
	while kill -0 $1 >/dev/null 2>&1
  	do
    		for i in ${spinner[@]};
    		do
      			echo -ne "\r${2} [ ${i} ]";
      			sleep 0.2;
   		done;
  	done
	echo -ne "\r${3}" ; echo
	
}


#-------------------------------------------------------------------------------------------
# Dependencies: Add any dependencies in below as a seperate function, make sure IO gets  
#		redirected to /dev/null, send process id to buffer and update 'dependencies'
#		function above by calling new dependecy function in it.	
#-------------------------------------------------------------------------------------------

# function for VMWare

apt_update(){
	apt update > /dev/null 2>&1 &
	buffer $! $1 "$2"
}

apt_upgrade(){
	apt full-upgrade -y --autoremove --purge > /dev/null 2>&1 &
	buffer $! $1 "$2"
}

Pip(){
	apt -y install python-pip > /dev/null 2>&1 &
	buffer $! $1 "$2"
}

GoLang() {

	apt install golang > /dev/null 2>&1 & 
	buffer $! $1 "$2"
	echo 'export PATH=$PATH:/root/go' >> /etc/profile ; source /etc/profile
	echo 'export PATH=$PATH:/root/go' >> /root/.profile; source /root/.profile	
}

#-------------------------------------------------------------------------------------------
# Dependencies Master call: Function for every Dependencies needed to be called from below
#			    'dependencies' function. Keep it updated if new dependencies are
#			    addded.
#-------------------------------------------------------------------------------------------

dependencies(){
	apt_update 'Installing.....(1/4)' "Installation Completed.....(1/4)"
	apt_upgrade 'Installing.....(2/4)' 'Installation Completed.....(2/4)'
	Pip 'Installing.....(3/4)' 'Installation Completed.....(3/4)'
	GoLang 'Installing.....(4/4)' 'Installation Completed.....(4/4)'
}

#-------------------------------------------------------------------------------------------
# Calling Dependencies
	dependencies


#------------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------------#
# Any new tool needed to be written in a seperate function and update array table's above  #
#------------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------------#

#Global Variables:
head="echo Currently working on:"

# function for NoMachine
NoMachine() {
	$head ${FUNCNAME[0]}
	Nomachine_deb="/root/Downloads/NoMachine.deb"
	curl -o $Nomachine_deb --create-dirs ${tools["NoMachine"]} -s &
	buffer $! Downloading..... "Download Completed....."
	dpkg -i /root/Downloads/NoMachine.deb > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

VMWare() {
	$head ${FUNCNAME[0]}
	VMWare_bundle="/root/Downloads/VMWareZbox.bundle"
	curl -L -o $VMWare_bundle --create-dirs ${tools["VMWare"]} -s &
	buffer $! Downloading..... "Download Completed....."
	chmod +x $VMWare_bundle ; $VMWare_bundle > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
	return 0
}

# function for Kerbrute
Kerbrute(){
	$head ${FUNCNAME[0]}
	go get ${tools["Kerbrute"]} &
	buffer $! Downloading..... "Download Completed....."
}

# function for Gowitness
Gowitness(){
	$head ${FUNCNAME[0]}
	go get -u ${tools["Gowitness"]} &
	buffer $! Downloading..... "Download Completed....."
}

# function for Impacket
Impacket(){
	$head ${FUNCNAME[0]}
	git clone ${tools["Impacket"]} /opt/impacket > /dev/null 2>&1 &
	buffer $! Downloading..... "Download Completed....."
	pip install /opt/impacket/. > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for CrackMapExec
CrackMapExec(){
	$head ${FUNCNAME[0]}
	git clone --recursive  ${tools["CrackMapExec"]} /opt/CrackMap > /dev/null 2>&1 &
	buffer $! Downloading..... "Download Completed....."
	pip install -r /opt/CrackMap/requirements.txt > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
	python /opt/CrackMap/setup.py install  > /dev/null 2>&1 &
}

# function for SLUserNames
SLUserNames(){
	$head ${FUNCNAME[0]}
	git clone ${tools["SLUserNames"]} > /dev/null 2>&1 &
	buffer $! Downloading..... "Download Completed....."
}

# function for SecList
SecList(){
	$head ${FUNCNAME[0]}
	git clone ${tools["SecList"]} > /dev/null 2>&1 &
	buffer $! Downloading..... "Download Completed....."
}

# function for Bettercap
Bettercap(){
	$head ${FUNCNAME[0]}
	apt install bettercap -y > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for Libreoffice 
Libreoffice() {
	$head ${FUNCNAME[0]}
	apt install libreoffice -y > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for Heimdal-clients
Heimdal_clients(){
	$head ${FUNCNAME[0]}
	apt install heimdal-clients -y > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# funtion for Bloodhound
Bloodhound() {
	$head ${FUNCNAME[0]}
	pip install bloodhound > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for Nessus
Nessus() {
	$head ${FUNCNAME[0]}; Nessus_deb="/root/Downloads/Nessus.deb"
	curl -o $Nessus_deb --create-dirs ${tools["Nessus"]} -s &
	buffer $! Downloading..... "Download Completed....."
	dpkg -i /root/Downloads/Nessus.deb > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

test_case(){
	echo "hello"
}

#-------------------------------------------------------------------------------------------
#					   M A I N					   #
#-------------------------------------------------------------------------------------------

for i in "${!yesORno[@]}";
do 
	if [ ${yesORno[$i]} == "y" -o ${yesORno[$i]} == "Y" ] ; then
		$i
	fi
done

#-------------------------------------------------------------------------------------------



