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

#	["VMWare"]="Y"
#	["NoMachine"]="Y"
#	["GoLang"]="Y"	
#	["Kerbrute"]="Y"
#	["Gowitness"]="Y"
#	["Impacket"]="Y"
#	["CrackMapExec"]="Y"
#	["SLUserNames"]="Y"
#	["SecList"]="Y"
#	["Nessus"]="Y"
#	["bettercap"]="Y"
#	["libreoffice"]="Y"
#	["heimdal_clients"]="Y"
#	["bloodhound"]="Y"
#	["Nessus"]="Y"
	["test_case"]="Y"
)

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

buffer(){
	spinner=( "|" "/" "-" "\\" )
	while kill -0 $1 >/dev/null 2>&1
  	do
    		for i in ${spinner[@]};
    		do
      			echo -ne "\r$2 [ $i ]";
      			sleep 0.2;
   		done;
  	done
	echo -ne "\r$3" ; echo
	
}

#-------------------------------------------------------------------------------------------
# Dependencies: add any dependencies in this function & make sure IO gets eaten by /dev/null
#-------------------------------------------------------------------------------------------

dependencies(){
	echo Installing Dependencies....
	apt -y install python-pip > /dev/null 2>&1
	buffer $! "Installing.....(1/2)" "Installation Completed.....(1/2)"
}

#-------------------------------------------------------------------------------------------
# Any New tool needed to be written in a seperate function and update array tabls's above
#-------------------------------------------------------------------------------------------

#Global Variables:
head="echo Currently working on:"

# function for VMWare
VMWare() {
	$head ${FUNCNAME[0]}
	VMWare_bundle="/root/Downloads/VMWareZbox.bundle"
	curl -L -o $VMWare_bundle --create-dirs ${tools["VMWare"]} -s &
	buffer $! Downloading..... "Download Completed....."
	chmod +x $VMWare_bundle ; $VMWare_bundle > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
	return 0
}

# function for GoLang
GoLang() {

	$head ${FUNCNAME[0]}
	apt install golang > /dev/null 2>&1 & 
	buffer $! Installing..... "Installation Completed....."
	echo 'export PATH=$PATH:/root/go' >> /etc/profile ; source /etc/profile
	echo 'export PATH=$PATH:/root/go' >> /root/.profile; source /root/.profile	
}

# function for NoMachine
NoMachine() {
	$head ${FUNCNAME[0]}
	Nomachine_deb="/root/Downloads/NoMachine.deb"
	curl -o $Nomachine_deb --create-dirs ${tools["NoMachine"]} -s &
	buffer $! Downloading..... "Download Completed....."
	dpkg -i /root/Downloads/NoMachine.deb > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for Kerbrute
kerbrute(){
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

# function for bettercap
bettercap(){
	$head ${FUNCNAME[0]}
	apt install bettercap -y > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for libreoffice 
libreoffice() {
	$head ${FUNCNAME[0]}
	apt install libreoffice -y /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for heimdal-clients
heimdal_clients(){
	$head ${FUNCNAME[0]}
	apt install heimdal-clients -y /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# funtion for bloodhound
bloodhound() {
	$head ${FUNCNAME[0]}
	pip install bloodhound /dev/null 2>&1 &
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
	echo $i
	if [ yesORno[$i] == "y" -o yesORno[$i] == "Y" ] ; then	
		$i
	fi
done





