#! /bin/bash
##########################################################################################################################
#Script Name	: IDS.sh
#Description	: Send alert to Telegram if it detects an unknown host.
#Args			:
#Author			: Carlos Pérez
#Email			: carlospcl98@gmail.com
#License		: GNU GPL-3
##########################################################################################################################

# Declare Telegram variables
TOKEN=""
ID=""

# Write the IP of your network // Escribe la IP de tu red
RED="192.168.0.0/24"

	#White_list is an array that contains known MAC addresses (White list) // Archivo que contiene las direcciones MAC conocidas (Lista blanca).
	white_list=$(cat white_list.txt | grep "MAC_Addres" | cut -c 13-30)

	#Array contains the MAC addresses of the hosts connected in your network // Contiene las direcciones MAC de los equipos conectados en tu red.
	connected_host_list=$(sudo nmap -sP $RED | grep "MAC Address" | awk '{print $3}')



#Check if the host exists in our whitelist // Verifica si el host existe en nuestra lista blanca
match=0
for connected_host in ${connected_host_list[@]}
do
		for known_host in ${white_list[@]}
		do
			if [ $connected_host == $known_host ]
				then
				match=1
				break
			fi
		done

	if [ $match == 1 ]
	then
		echo "$connected_host es conocida..."

	else
		#Send an alarm to our telegram // Envia una alarma a nuestro telegram
		MESSAGE="Creo que he visto un intruso en tu red, su MAC es: $connected_host "
		URL="https://api.telegram.org/bot$TOKEN/sendMessage"
		
		curl -s -X POST $URL -d chat_id=$ID -d text="$MESSAGE"
		echo -e "\n Te hemos notificado a tu Telegram"
	fi
	match=0
done


	
