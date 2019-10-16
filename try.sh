#!/bin/bash
#
# ZBox setup
#
# Any file edited in this script with "sid" will 
# have a backup file with ".bak" extention.
#


#-----------------------------------------------------------------------------
set -x

: <<'END'
declare -A tools=(

	["VMWare"]="https://www.vmware.com/go/getplayer-linux"
	["OpenVPN"]="https://vpn.chiseclab.com/?src=connect"
	["GoLang"]="https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz"
	["Kerbrute"]="github.com/ropnop/kerbrute"
	["Gowitness"]="github.com/sensepost/gowitness"
	["Impacket"]="https://github.com/SecureAuthCorp/impacket"
	["CrackMapExec"]="https://github.com/byt3bl33d3r/CrackMapExec"
	["LDAPDomaindump"]="https://github.com/dirkjanm/ldapdomaindump"
	["SLUserNames"]="https://github.com/insidetrust/statistically-likely-usernames"
	["KinitHorBrute"]="https://raw.githubusercontent.com/ropnop/kerberos_windows_scripts/master/kinit_horizontal_brute.sh"
	["EyeWitness"]="https://github.com/FortyNorthSecurity/EyeWitness"
	["Nessus"]="https://www.tenable.com/downloads/nessus"
	["NoMachine"]="https://www.nomachine.com/download/download&id=3"
)

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

# Set the debugger mode ON
set -x

#-------------------------------------------------------------------------------------------

# Enable the ssh and edit 'sshd_config' file

file_path='/etc/ssh/sshd_config'
update-rc.d ssh enable
sed -i.bak s/"#PermitRootLogin prohibit-password"/"PermitRootLogin yes"/ $file_path


#-------------------------------------------------------------------------------------------

# checkpoint whether going full install or manual 

hardWay=""
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

#-------------------------------------------------------------------------------------------
# Any New tool needed to be written in a seperate function 
#-------------------------------------------------------------------------------------------
END
# function for VMWare
VMWare() {
	wget -P /root/Downloads https://www.vmware.com/go/getplayer-linux
	/root/Downloads/
}

# function for OpenVPN
# function for GoLang
# function for Kerbrute
# function for Gowitness
# function for Impacket
# function for CrackMapExec
# function for LDAPDomaindump
# function for SLUserNames
# function for KinitHorBrute
# function for EyeWitness
# function for Nessus"]
# function for NoMachine


$VMWare
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




