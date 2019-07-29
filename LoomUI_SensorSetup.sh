#!/bin/bash
#Author: Andrew Collins
#Filename: LoomUI_SensorSetup.sh
#Description: This is a user interface that allows addition of
#sensors to our network. Aka Creates all file necessary for a sensor
# to start dataloggin.
#Run: ./LoomUI_SensorSetup.sh
#give program permission initially "chmod +x LoomUI_Setup.sh"

ConfigureSensorSketchFile(){ 
#$1=sensor Type  $2=Sensor  $3=Sensor ID $4=Sensor Dire name $5=sensor sketch dir name $6=sensor sketck file name 
clear
echo Time to create arduino sketch file.
while :
do
read -p 'Enter network name(SSID): ' ssid
read -p 'Enter network password: ' password
echo
read -p 'Enter Server IP: ' serverip
read -p 'Enter Server listening port: ' serverport

while :
do
read -p 'Enter data logging interval in minutes ( whole between 0 - 1441): ' loginterval
case $loginterval in
	*[!0-9*] | "")
	echo Invalid input.
	continue
	;;
	*)
		if [ "$loginterval" -gt "0" ] && [ "$loginterval" -lt "1441" ]
		then
		echo Good value
		break
	fi
	;;
esac

echo Invalid input
done


clear
echo You entered:
echo Network Name \(ssid\): $ssid
echo Password: $password
echo Server IP: $serverip
echo Server port: $serverport
echo Data logging interval: $loginterval
read -p 'Are the previous values correct (y or n)? ' answer
if [ "$answer" = "y" ]
then
	break
elif [ "$answer" = "n" ] 
then
	continue
else
	echo Invalid input.
fi
done

subpath="./SensorFiles/$4/$5/$6"
#Time to write to files
#char ssid[]=SECRET_SSID;//your network SSID (name)
#char pass[]=SECRET_PASS;//your network password (use for WPA, or use a key for WEP)
#String DeviceID ="111001";
#const char * host = "192.168.1.133";//ip on which server is running
#const uint16_t port = 8090;

echo "$loginterval" >> "./SensorFiles/$4/SensorConfig$3.txt"
#follow sed commands on work for BSD version of sed
sed -i '' "11a\\
#define SECRET_PASS \"$password\"
" $subpath

sed -i '' "11a\\
#define SECRET_SSID \"$ssid\"
" $subpath

sed -i '' "11a\\
#define LOG_INTERVAL $loginterval
" $subpath

sed -i '' "11a\\
#define PORT $serverport
" $subpath 

sed -i '' "11a\\
#define IP_ADDR \"$serverip\"
" $subpath


sed -i '' "11a\\
#define DEVICE_ID \"$3\"
" $subpath
}

CreateSensorsrc_Dir(){

#$1=sensor Type  $2=Sensor  $3=Sensor ID $4=Sensor Dire name 
	
#Edit code below to add new sensor, follow format below
case $1 in 
	Salinity)
	echo Creating sensor source directory ./SensorFiles/$4/ClientSalinitySensor$3 for $1 $2 Id: $3
	mkdir "./SensorFiles/$4/ClientSalinitySensor$3"
	echo Copying Salinity Sensor source code
	echo No source file for salinity sensor yet
	cp ./src/Sensor_src/ClientSalinitySensor.ino "./SensorFiles/$4/ClientSalinitySensor$3/ClientSalinitySensor$3.ino" 
	ConfigureSensorSketchFile $1 $2 $3 $4 "ClientSalinitySensor$3" "ClientSalinitySensor$3.ino"   	
	;;
	PH)
	echo Creating sensor source directory ./SensorFiles/$4/ClientPHSensor$3 for $1 $2 Id: $3
	mkdir "./SensorFiles/$4/ClientPHSensor$3"
	echo Copying PH Sensor source code
	echo No source file for PH sensor yet
	#cp ./src/Sensor_src/ClientPHSensor.ino "./SensorFiles/$4/ClientPHSensor$3/ClientPHSensor$3.ino" 
	#ConfigureSensorSketchFile $1 $2 $3 $4 "ClientPHSensor$3" "ClientPHSensor$3.ino"   	
	;;
	Hall-Effect)
	echo Creating sensor source directory ./SensorFiles/$4/ClientHall-EffectSensor$3 for $1 $2 Id: $3
	mkdir "./SensorFiles/$4/ClientHall-EffectSensor$3"
	echo Copying Hall-Effect Sensor source code
	echo No source file for Hall-Effect sensor yet
	#cp ./src/Sensor_src/ClientHall-EffectSensor.ino "./SensorFiles/$4/ClientHall-EffectSensor$3/ClientHall-EffectSensor$3.ino" 
	#ConfigureSensorSketchFile $1 $2 $3 $4 "ClientHall-EffectSensorSensor$3" "ClientHall-EffectSensor$3.ino"   	
	;;
	Flow)
	echo Creating sensor source directory ./SensorFiles/$4/ClientFlowSensor$3 for $1 $2 Id: $3
	mkdir "./SensorFiles/$4/ClientFlowSensor$3"
	echo Copying Flow Sensor source code
	echo No source file for Flow sensor yet
	cp ./src/Sensor_src/ClientFlowSensor.ino "./SensorFiles/$4/ClientFlowSensor$3/ClientFlowSensor$3.ino" 
	ConfigureSensorSketchFile $1 $2 $3 $4 "ClientFlowSensor$3" "ClientFlowSensor$3.ino"   	
	;;
	Temperature)
	echo Creating sensor source directory ./SensorFiles/$4/ClientTemperatureSensor$3 for $1 $2 Id: $3
	mkdir "./SensorFiles/$4/ClientTemperatureSensor$3"
	echo Copying Temperature Sensor source code
	cp ./src/Sensor_src/ClientTemperatureSensor.ino "./SensorFiles/$4/ClientTemperatureSensor$3/ClientTemperatureSensor$3.ino" 
	ConfigureSensorSketchFile $1 $2 $3 $4 "ClientTemperatureSensor$3" "ClientTemperatureSensor$3.ino"   	
	;;
	*)
	echo invalid sensor input source section
	;;
esac


}


CreateSensorData_File(){

#$1=sensor Type  $2=Sensor  $3=Sensor ID $4=Sensor Dire name 
echo Creating sensor Data file .SensorFiles/$4/SensorData$3.csv for $1 $2 Id: $3
#check if file already exists
echo This is the Data file for the $1 $2 ID : $3  > "./SensorFiles/$4/SensorData$3.csv"
#cat ./SensorFiles/$4/SensorData$3.csv

#push colum headers to file

#Edit code below to add new sensor, follow format below
case $1 in 
	Salinity)
	echo Add Sensor column headers
	;;
	PH)
	echo Add Sensor column headers
	;;
	Hall-Effect)
	echo Add Sensor column headers
	;;
	Flow)
	echo Add Sensor column headers
	;;
	Temperature)
	echo Add Sensor column headers
	echo DeviceID,Humidity,Temperature C,Temperature F,Time Stamp >> "./SensorFiles/$4/SensorData$3.csv"
	;;
	*)
	echo invalid sensor input source section
	;;
esac


#-------------------------
}

CreateSensorConfig_File(){

#$1=sensor Type  $2=Sensor  $3=Sensor ID $4=Sensor Dire name 
echo Creating sensor config file ./SensorFiles/$4/SensorConfig$3.txt for $1 $2 Id: $3
#check if file already exists
echo This is the configuration file for the $1 $2 ID : $3  > "./SensorFiles/$4/SensorConfig$3.txt"
#cat ./SensorFiles/$4/SensorConfig$3.txt
#--------push colum headers to file


}

CreateSensor_directory(){

#check if directory already exists
echo Creating directory Sensor$3 for $1 $2 Id: $3
mkdir "./SensorFiles/Sensor$3"


#$1=sensor Type  $2=Sensor  $3=Sensor ID  
CreateSensorConfig_File $1 $2 $3 "Sensor$3" 
CreateSensorData_File $1 $2 $3 "Sensor$3" 
CreateSensorsrc_Dir  $1 $2 $3 "Sensor$3"
echo
echo Directory Tree
find ./SensorFiles -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
echo
}

AddtoLISTofSensors(){

SensorList=./SensorFiles/ListOfSensors.txt
#echo $SensorList

#cat $SensorList
#cat ./SensorFiles/ListOfSensors.txt
#cat -e $SensorList | tail -n 1 #check if last line in file in newline
#while [ $(test $ = $(cat -e $SensorList | tail -n 1)) ; echo $? ] #check if last line in file in newline
#do
#sed -i '' -e '$ d' $SensorList
#done

#-----neeed to add logic if 0 sensors in file
#echo $SensorList

MaxSensorNum=$(tail -n 1 $SensorList | cut -d ' ' -f 1)
#echo MaxSensorNum: $MaxSensorNum

#do check before assignment

NewSensorNum=$(($MaxSensorNum + 1))
#echo NewSensorNum: $NewSensorNum

#echo $NewSensorNum $1 $2 $(date) 
#echo $NewSensorNum $1$2 $(date) >> $SensorList
echo $NewSensorNum $1$2  >> $SensorList

#$1=sensor Type  $2=Sensor
CreateSensor_directory $1 $2 $NewSensorNum
}

#adding sensor function:
add_sensor(){

#To add additional sensors, follow all format. Find commented lines 
#that require new commands that will hell you add a new sensor to the UI

#Edit code below to add new sensor, follow format below
while :
do
echo
echo Avaliable sensors:
echo 0-Salinity sensor
echo 1-PH Sensor
echo 2-Hall-Effect Sensor
echo 3-Flow Sensor
echo 4-Temperature Sensor
echo Enter q to quit.
	

read -p 'Enter the sensor number: ' sensornum

echo
#Edit code below to add new sensor, follow format below
case $sensornum in 
	0)
	echo Adding Salinity sensor
	AddtoLISTofSensors Salinity Sensor
	break
	;;
	1)
	echo Adding PH Sensor
	AddtoLISTofSensors PH Sensor
	break
	;;
	2)
	echo Adding Hall-Effect Sensor
	AddtoLISTofSensors Hall-Effect Sensor
	break
	;;
	3)
	echo Adding Flow Sensor
	AddtoLISTofSensors Flow Sensor
	break
	;;
	4)
	echo Adding Temperature Sensor
	AddtoLISTofSensors Temperature Sensor
	break
	;;
	q)
	echo Quitting
	exit 0
	break
	;;
	*)
	echo invalid input
	;;
esac

done
}


#removing sensor function
remove_sensor(){
cat ./SensorFiles/ListOfSensors.txt
echo Enter q to quit.

read -p 'From list of sensors above, enter sensor ID to remove: ' sensorid

if [ "$sensorid" = "q" ]
then
	echo quiting
	clear
	exit 0 
fi
if [ "$sensorid" = "111000" ]
then
	echo This is not a sensor that can be deleted.
elif [ -d "./SensorFiles/Sensor$sensorid" ]
then
	echo Are you sure you want to delete the following files:
	find ./SensorFiles/Sensor$sensorid -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
	read -p 'Enter y or n: ' userinys
	if [ "$userinys" = "y" ]
	then
		sed -i '' "/$sensorid/d" ./SensorFiles/ListOfSensors.txt
		rm -fr ./SensorFiles/Sensor$sensorid
		clear
	elif [ "$useinys" = "n" ]
	then
		echo
		clear 	
	else
		echo Error:Invalid input.
	fi
		
else
	echo Error: Invalid Sensor id
fi



}


change_dataloginterval(){
cat ./SensorFiles/ListOfSensors.txt
echo Enter q to quit.
read -p 'From list of sensors above, enter sensor ID of sensor to configure: ' sensor_id

if [ "$sensor_id" = "q" ]
then
	echo quiting
	clear
	exit 0 
fi


if [ "$sensor_id" = "111000" ]
then
	echo This is not a sensor that can be deleted.
elif [ -d "./SensorFiles/Sensor$sensor_id" ] && [ -w "./SensorFiles/Sensor$sensor_id/SensorConfig$sensor_id.txt" ]
then
	clear
	echo -e "Current data loggin interval in file SensorConfig$sensor_id.txt: \c"
	tail -n 1 ./SensorFiles/Sensor$sensor_id/SensorConfig$sensor_id.txt
	echo

	while :
	do
	echo "Enter q to quit."
	read -p 'Enter New data logging interval in minutes ( whole between 0 - 1441): ' log_interval	
	case $log_interval in
		q)
			break
		;;
		*[!0-9*] | "")
		echo Invalid input.
		continue
		;;
		*)
			if [ "$log_interval" -gt "0" ] && [ "$log_interval" -lt "1441" ]
			then
			sed -i '' -e '$ d'  ./SensorFiles/Sensor$sensor_id/SensorConfig$sensor_id.txt
			echo  $log_interval >>  ./SensorFiles/Sensor$sensor_id/SensorConfig$sensor_id.txt
			echo Good value
			break
			else
				echo Invalid input.
			fi
			
		;;
	esac
	done
		
else
	echo Error: Invalid Sensor id
fi

}

while :
do
echo 
echo Tasks:
echo 0-add sensor
echo 1-remove sensor
echo 2-change sensor data logging interval
echo Enter q to quit.

read -p 'Enter the number for Task: ' userin
echo ${#userin} #number of argument entered

clear

if [ "$userin" = "0" ]
then
	echo add sensor
	add_sensor
elif [ "$userin" = "1" ]
then
	echo remove sensor
	remove_sensor
elif [ "$userin" = "2" ]
then
	echo change sensor data logging interval
	change_dataloginterval
elif [ "$userin" = "q" ]
then
	echo quit
	exit 0
else
	echo invalid input
fi

done

