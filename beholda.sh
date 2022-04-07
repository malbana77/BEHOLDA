#!/bin/bash
	mkdir port_scan 2>/dev/null
	cd port_scan
	cat ../Files/logo.txt
	echo ""
        echo -e "\e[31m[Host Discovery]\e[0m"
	yn=$(ip a | grep inet | grep -v inet6 | grep -v 127 | cut -d " " -f 6)
	NET=$yn
	ipp=$(echo $yn | cut -d "." -f 1)
	sleep 3
	python3 ../Files/Check_hosts.py -t $NET -o
	for i in {243..248} {248..243} ; do echo -en "\e[38;5;${i}m######\e[0m" ; done ; echo
	echo -e "\e[31m[Port Scanning]\e[0m"
	###################FUNCTION##########################
vers () {
	file=$1

	while read line ; do

		port=$(echo "$line"|grep "portid" | cut -d "'" -f 4  )
		if [ ! -z $port ]
		then
			po=$port
		fi
		ser=$(echo "$line"|grep "name" | cut -d "'" -f 6 | grep -v "hostname")
		if [ ! -z $ser ]
		then
			sr=$ser
		fi

		ver=$(echo "$line"|grep "product"  | cut -d "'" -f 4 )
		v=$(echo $ver | cut -d " " -f 1)
		if [ ! -z $v ]
		then
			vr=$ver
		fi
		if [[ ! -z "$po" && ! -z "$sr" && ! -z "$vr" ]]
		then
			printf "$po	" >>.re1.txt
			printf "$sr		"  >>.re1.txt
			echo "$vr"  >>.re1.txt
			po=""
			sr=""
			vr=""
		else

			continue
		fi
	done < ${file}
	ops=$(cat .scan.txt |grep "OpSy" |cut -d ":" -f 2  )
	cat .re1.txt
	echo -e "Operating System:\e[38;5;246m$ops\e[0m"
	rm .scan.txt
}



PS3="Enter your choose :# " export PS3
select loop in 'All Network' 'Specific IP'
do
if [ "$loop" == 'All Network' ]
then
	file=hosts.txt
	rm report* $ipp* 2>/dev/null
	while read line ; do
		ip=$(echo "$line" )
			rm .*  O* 2>/dev/null
			echo -e "IP ADDRESS : \e[41m$line\e[0m"
			python3 ../Files/Check_ports.py -t $ip > .Oport_$ip
			cat .scan.txt | sed 's/,/\n/g' > Oport_$ip
			er=$(cat .scan.txt |grep "open")
			if [ ! -z $er ] 2>/dev/null
			then

				echo -e "All ports is \e[96mClosed|\e[38;5;208mFiltered\e[0m"
			else
				echo -e "\e[32m[-] These ports are \e[5mopened\e[0m"
				echo -e "\e[4mport	service		version\e[0m"
				vers Oport_$ip
				rm .*  O*  2>/dev/null
			fi
			echo ""
	done < ${file}
	rm .*  O*  2>/dev/null
	exit
	
	
	
elif [ "$loop" == 'Specific IP' ]
then
	echo ""
	printf 'Enter ip : '
	read sip
	file=hosts.txt
	rm $sip 2>/dev/null
	while read line ; do
		if [ $sip == $line ]
		then
			rm .*  O*  2>/dev/null
			echo -e "IP ADDRESS : \e[41m$sip\e[0m"
			python3 ../Files/Check_ports.py -t $sip > .Oport_$sip 
			cat .scan.txt | sed 's/,/\n/g' > Oport_$sip
			er=$(cat .scan.txt |grep "open")
			if [ -z $er ] 2>/dev/null
			then
				echo -e "All ports is \e[96mClosed|\e[208mFiltered\e[0m"
			else
				echo -e "\e[32m[-] These ports are \e[5mopened\e[0m"
				echo -e "\e[4mport	service		version\e[0m"
				vers Oport_$sip
				rm .*  O*  2>/dev/null

			fi

		fi
	done < ${file}
	exit
fi
done
exit
