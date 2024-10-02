int soil = A0; 
int temp = A3;
int pump = A5;

void setup() {
  
  Serial.begin(9600);

  pinMode(soil, INPUT);
  pinMode(temp, INPUT);
  pinMode(pump, OUTPUT);
}

void loop()
{
 
  int soil = analogRead(A0);  // Reading Analog value from Sensor
 Serial.print("Soil sensor Value : ");
  Serial.print(soil);
  delay(10); 

  int temp = analogRead(A3);
  float voltage = temp * (5000 / 1024.0);
  float temperature = (voltage - 500) / 10;
  // Print the temperature in the Serial Monitor:
  Serial.print("   Temperature : ");
  Serial.print(temperature);
  Serial.print(" \xC2\xB0"); // shows degree symbol
  Serial.println("C");
  delay(250);


if(soil>= 600 && temp <=25 )
{digitalWrite(pump,LOW);}  

else if(soil>= 600 && temp >25 )
{ digitalWrite(pump,LOW);} 
 
else if(soil< 600 && temp <=25 )
{ digitalWrite(pump,LOW);} 

else if(soil< 600 && temp >25 )
{ digitalWrite(pump,HIGH);} 
}