/**
 * Simple Read Multiple Vars
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int temp;      // Data received from the serial port
int goal;      // Data received from the serial port
int relay;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];

  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if(myPort.available() >= 2)
  {
    switch (byte(myPort.read()))
    {
      case 'c':
        temp = myPort.read();
        temp = int(float(temp)/float(255)*1000);
        break;
      case 'g':
        goal = myPort.read();
        goal = int(float(goal)/float(255)*1000);
        break;
      case 'r':
        relay = myPort.read();
        break;
    }
  }
  
  println(temp+" "+goal+" "+relay);
}
