//Author: Andrew Collins and Zoran Bi
//Sensor: Flow Rate Sensor

#include <SPI.h>
#include <WiFi101.h>

//Do not write below this line. UI will add lines below



//Do not write above this line.UI will add lines above

char ssid[]=SECRET_SSID;//your network SSID (name)
char pass[]=SECRET_PASS;//your network password (use for WPA, or use a key for WEP)
String DeviceID =DEVICE_ID;
const char * host = IP_ADDR;//ip on which server is running
const uint16_t port = PORT;

String Log_Interval_String="";
unsigned long Log_Interval=1;


int KeyIndex=0;//your network key Index number (for WEP)

int status = WL_IDLE_STATUS;// the WiFi radio's status

int analogPin = A0;     // potentiometer wiper (middle terminal) connected to analog pin 3
int val = 0;           // variable to store the value read
float vol = 0;
float sum = 0;
float mean = 0;
float DataArray = {};
float rate = 0;

void setup(){
	WiFi.setPins(8,7,4,2);

	//Initialize serial and wait for port to open
	//Serial.begin(9600);
//while(!Serial){
	//	;
//	}


	WifiSecureConnect();
	//WifiOpenConnect();
}

/*-----------------Start: Main Loop-----------------*/
void loop(){


  ReadFlowRate();
  Serial.println();
  Serial.println();

delay(Log_Interval*60000);
	//ServerCommunication();

}
/*-----------------End:Main Loop-----------------*/


/*-----------------Start: Secure Wifi Connect -----------------*/
void WifiSecureConnect(){
Serial.print("Attempting to connect to WiFi network: ");
Serial.println(ssid);

	//attempt to connect to  WiFi network:
	while(status != WL_CONNECTED){
		Serial.print("Attempting to connect to SSID: ");
		Serial.println(ssid);

		//Connect to WPA/WPA2 network
		status = WiFi.begin(ssid, pass);

		//Connect to WPE
		//status = WiFI.begin(ssid,KeyIndex,key);

		//wait 10 seconds for connection
		delay(10000);
	}

	//Once you are connected
	//Serial.print("You're conected to the network");
	printWiFiStatus();
  Serial.println();
  Serial.println();
}
/*-----------------End: Secure Wifi Connect -----------------*/

/*-----------------Start: Open Wifi Connect -----------------*/
void WifiOpenConnect(){

Serial.print("Attempting to connect to WiFi network: ");
Serial.println(ssid);

	while (status != WL_CONNECTED){
		//Serial.print("Attempting to connct to open SSID: ");
	//	Serial.println(ssid);
		status =WiFi.begin(ssid);

		delay (10000);
	}
	printWiFiStatus();

}
/*-----------------End: Open Wifi Connect -----------------*/


/*-----------------Start: Print wifi Status -----------------*/
void printWiFiStatus(){
	//print the SSID of the network you're attached to:
	Serial.print("Network SSID: ");
	Serial.println(WiFi.SSID());
	//print network type:
	byte encryption = WiFi.encryptionType();
	//Serial.print(" Network Encryption Type:");
	//Serial.println(encryption, HEX);
	//Serial.println(" ------------------------------------------");

	//print your WiFi sheild's IP address:
	IPAddress ip = WiFi.localIP();
	Serial.print("My IP Address: ");
	Serial.println(ip);

	//print your MAC address:
	byte mac[6];
	WiFi.macAddress(mac);
	//Serial.print("My MAC address: ");
	//Serial.print(mac[5],HEX);
	//Serial.print(":");
  //Serial.print(mac[4],HEX);
  //Serial.print(":");
  //Serial.print(mac[3],HEX);
  //Serial.print(":");
  //Serial.print(mac[2],HEX);
  //Serial.print(":");
  //Serial.print(mac[1],HEX);
  //Serial.print(":");
  //Serial.println(mac[0],HEX);

	//print the received signal strength:
	long rssi = WiFi.RSSI();
  //Serial.print("Signal strength (RSSI):");
  //Serial.print(rssi);
  //Serial.println(" dBm");
}
/*-----------------End: Print wifi Status -----------------*/


/*-----------------Start: Server Communication-----------------*/
void ServerCommunication(String ID, String msg){

Serial.print("Attempting to connect to Server/Host:");
	Serial.print(host);
	Serial.print(" : ");
	Serial.print("Port");
	Serial.println(port);

	WiFiClient client;

	if(!client.connect(host,port)){
		Serial.println("Connection failed");
		delay(5000);
		return;
	}

//	Serial.println("Connected to server successful!");

String message= String(ID+","+msg);
	//sending data to server
//	Serial.print("Sending Data to server:");
//  Serial.println("msg");
	if(client.connected()){
		//client.println("This is my data sent by client");
   client.println(message);
	}

	//wait for server to sent message
	//timeout after 6 seconds
	unsigned long timeout = millis();
	while (client.available() == 0){ //while no bytes recived
		if(millis() - timeout > 6000){
//			Serial.println("-----Done waiting-----");
			client.stop();
			delay(5000);
			return;
		}
	}

	//Server message received
Serial.print("Server message received: ");
Log_Interval_String="";
	while(client.available()){
		char ch = static_cast<char>(client.read());
		Serial.print(ch);
   Log_Interval_String+=ch;
	}
Serial.print("Log interval string");
Serial.println(Log_Interval_String);

Log_Interval=atol(Log_Interval_String.c_str());
Serial.print("Log interval unsigned long");
Serial.println(Log_Interval);
	//End Connection
  //Serial.println("Ending connection with Server");
	client.stop();



//	Serial.println();
	return;
}
/*-----------------Start: Server Communication-----------------*/


/*-----------------Start: Flow Rate Sensor-----------------*/
void ReadFlowRate(){
//delay(2000);

  for(int i = 0; i < 100; i ++){
      val = analogRead(analogPin);
      vol = val * (3.3 / 1024.0);
      sum = sum + vol;
      delay(5);
   }
   
   mean = sum / 100;
//   Serial.println(mean, 5);
   rate = 9.8699 * exp(-2.124 * mean);
//   rate = -7.5357*pow(mean,5) + 74.032*pow(mean,4) - 289.46*pow(mean,3) + 563.15*pow(mean,2) - 545.67*mean + 211.17;

   if (rate < 0.05 ){
    Serial.println("Out of range");
   }
   else if(rate > 0.5){
    Serial.println("Out of range");
   }
   else{
    Serial.println(rate, 3);
   }
   sum = 0;
   //delay(200);

  Serial.print(F("Rate: "));
  Serial.print(rate);

  String rate_s = String(rate,3);
 


  String message = String("Flow Rate:,"+rate_s);
  Serial.println(message);
  //send to server
  ServerCommunication(DeviceID, message);
}
/*-----------------End: Flow Rate Sensor-----------------*/
