#!/bin/bash
#
# ZBox setup
#
# Maintenance: REQUIRED
#
# Any file edited in this script with "sid" will 
# have a backup file with ".bak" extention.
#


#-----------------------------------------------------------------------------

echo ':::::::::  :::::::::    ::::::::   :::    ::: '
echo '     :+:   :+:    :+:  :+:    :+:  :+:    :+: '
echo '    +:+    +:+    +:+  +:+    +:+   +:+  +:+  '
echo '   +#+     +#++:++#+   +#+    +:+    +#++:+   '
echo '  +#+      +#+    +#+  +#+    +#+   +#+  +#+  '
echo ' #+#       #+#    #+#  #+#    #+#  #+#    #+# '
echo '#########  #########    ########   ###    ### '



declare -A tools=(

	["VMWare"]="https://www.vmware.com/go/getplayer-linux"
	["GoLang"]="https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz"
	["NoMachine"]="https://download.nomachine.com/download/6.8/Linux/nomachine_6.8.1_1_amd64.deb"	
	["Kerbrute"]="github.com/ropnop/kerbrute"
	["Gowitness"]="github.com/sensepost/gowitness"
	
	["Impacket"]="https://github.com/SecureAuthCorp/impacket"
	["CrackMapExec"]="https://github.com/byt3bl33d3r/CrackMapExec"
	["LDAPDomaindump"]="https://github.com/dirkjanm/ldapdomaindump"
	["SLUserNames"]="https://github.com/insidetrust/statistically-likely-usernames"
	["KinitHorBrute"]="https://raw.githubusercontent.com/ropnop/kerberos_windows_scripts/master/kinit_horizontal_brute.sh"
	["EyeWitness"]="https://github.com/FortyNorthSecurity/EyeWitness"
	["Nessus"]="https://www.tenable.com/downloads/nessus"
	["OpenVPN"]="https://vpn.chiseclab.com/?src=connect"
	
)
: <<'END'
declare -A yesORno=(

	["VMWare"]="Y"
	["OpenVPN"]="Y"
	["GoLang"]="Y"
	["Kerbrute"]="Y"
	["Gowitness"]="Y"
	["Impacket"]="Y"
	["CrackMapExec"]="Y"
	["LDAPDomaindump"]="Y"
	["SLUserNames"]="Y"
	["KinitHorBrute"]="Y"
	["EyeWitness"]="Y"
	["Nessus"]="Y"
	["NoMachine"]="Y"
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

	 		yesORno[$i]=$yORn
	fi
END
#-------------------------------------------------------------------------------------------

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
# Any New tool needed to be written in a seperate function 
#-------------------------------------------------------------------------------------------



# function for VMWare
VMWare() {
	echo "******************* VMWare *******************"
	VMWare_bundle="/root/Downloads/VMWareZbox.bundle"
	curl -L -o $VMWare_bundle --create-dirs ${tools["VMWare"]} -s &
	buffer $! Downloading..... "Download Completed....."
	chmod +x $VMWare_bundle ; $VMWare_bundle > /dev/null 2>&1 &
	buffer $s! Installing..... "Installation Completed....."
	return 0
}

# function for GoLang
GoLang() {

	echo "******************* GoLang *******************"
	apt install golang > /dev/null 2>&1 & 
	buffer $! Installing..... "Installation Completed....."
	echo 'export PATH=$PATH:/root/go' >> /etc/profile ; source /etc/profile
	echo 'export PATH=$PATH:/root/go' >> /root/.profile; source /root/.profile
	
	
}

# function for NoMachine
NoMachine() {
	echo "******************* NoMachine *******************"
	Nomachine_deb="/root/Downloads/NoMachine.deb"
	curl -o $Nomachine_deb --create-dirs ${tools["NoMachine"]} -s &
	buffer $! Downloading..... "Download Completed....."
	dpkg -i /root/Downloads/NoMachine.deb > /dev/null 2>&1 &
	buffer $! Installing..... "Installation Completed....."
}

# function for Kerbrute
kerbrute(){
	go get ${tools["Kerbrute"]} &
	buffer $! Downloading..... "Download Completed....."
}

# function for Gowitness
Gowitness(){
	go get -u ${tools["Gowitness"]} &
	buffer $! Downloading..... "Download Completed....."
}

# function for Impacket
Impacket(){
	git clone ${tools["Impacket"]} /opt/impacket &
}
# function for CrackMapExec
# function for LDAPDomaindump
# function for SLUserNames
# function for KinitHorBrute
# function for EyeWitness
# function for Nessus"]
# function for NoMachine
# function for OpenVPN

Impacket
#-------------------------------------------------------------------------------------------

: <<'END'
while [ "$hardWay" == "y" -o "$hardWay" == "Y" -o "$hardWay" == "n" -o "$hardWay" == "N"]f 
do
	read -p "Do you want to go Manually [y] or Hail Mary [n]: (y/n): " hardWay
done

	done

	for j in "${yesORno[@]}"
	do
		echo $j
	done

END




