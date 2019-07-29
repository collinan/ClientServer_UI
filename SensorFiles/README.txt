Author: Andrew Collins
This Directory contains files required for sensor data logging

Filename: ListOfSensors.txt
Description: List of sensor contains the unique ID of each sensor on our server, this id is added to the file when a user adds a sensor using the UI. For the server to accept
data from a sensor its ID needs to be in this file.

Directory: Sensor111002
Description: this an example directory for a sensor, created by the UI.
It contains the :
SensorConfig111002.txt :contains the sensors logging interval
SensorData111002.csv : log of all data sent from the sensor
ClientTemperatureSensor111002: Directory contains the sketch file to be uploaded 
				to the sensor module. This is also created by the UI. 
 