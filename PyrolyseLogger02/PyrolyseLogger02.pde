/**
 * ToDo:
 * / Fix stepX issue
 * / Log to file
 * / logfile, begin with date and time 
 * Energy op de Y as schalen 
 * Add markers to logfile
 * Accurate time
 */

import processing.serial.*;

Serial myPort;
int temp;
int goal;
int relay;
int energy;
int energyCostPerSecond = 20;

SimpleLineGraph goalGraph;
SimpleLineGraph relayGraph;
SimpleLineGraph energyGraph;
SimpleLineGraph tempGraph;

PFont font;

PrintWriter output;

int counter = 0;

void setup() 
{
  // config
  size(700,700);
  frameRate(31);
  //frameRate(1);
  smooth();
  
  // connection
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  // visuals
  goalGraph = new SimpleLineGraph();
  goalGraph.maxValue = 1000;
  goalGraph.graphColor = #ff3300;
  goalGraph.x = 10;
  goalGraph.y = 10;
  
  relayGraph = new SimpleLineGraph();
  relayGraph.maxValue = 1;
  relayGraph.graphColor = #0066ff;
  relayGraph.x = 10;
  relayGraph.y = 10;
  
  energyGraph = new SimpleLineGraph();
  energyGraph.maxValue = 1000;
  energyGraph.graphColor = #ffff00;
  energyGraph.x = 10;
  energyGraph.y = 10;
  energyGraph.autoScaleY = true;
  
  tempGraph = new SimpleLineGraph();
  tempGraph.maxValue = 1000;
  tempGraph.graphColor = #33ff00;
  tempGraph.x = 10;
  tempGraph.y = 10;
  
  font = createFont("Monospaced-12.vlw",12);
  textFont(font);
  
  startRecordingToFile();
}
void draw() 
{
  
  Boolean newData = false;
  // reading and storing data from microprocessor 
  if(byte(myPort.read()) == '|')
  {
    while(myPort.available() > 2)
    {
      switch (byte(myPort.read()))
      {
        case 'c':
          temp = myPort.read();
          temp = int(float(temp)/float(255)*1000);
          tempGraph.appendValue(temp);
          break;
        case 'g':
          goal = myPort.read();
          goal = int(float(goal)/float(255)*1000);
          goalGraph.appendValue(goal);
          break;
        case 's':
          relay = myPort.read();
          relayGraph.appendValue(relay);
          if(relay == 1)
            energy += energyCostPerSecond;
          energyGraph.appendValue(energy);
          break;
        case 'r':
          int reset = myPort.read();
          reset();
          break;
      }
    }
    newData = true;
  }
  
  if(keyPressed && key == 'd')
  {
    //counter++;
    //if(counter <= 10)
    tempGraph.appendValue(round(random(0,1000)));
    goalGraph.appendValue(round(random(0,1000)));
    relayGraph.appendValue(round(random(0,1000)));
    energyGraph.appendValue(round(random(0,5000)));
    newData = true;
  }
  
  background(0);
  
  // drawing graphs
  goalGraph.draw();
  relayGraph.draw();
  energyGraph.draw();
  tempGraph.draw();
  
  // drawing labels
  float nextY = goalGraph.y+goalGraph.graphHeight+20;
  int spacingY = 15;
  fill(goalGraph.graphColor);
  text("y: Goal (0-1000)"         ,goalGraph.x,nextY);
  nextY += spacingY;
  fill(tempGraph.graphColor);
  text("y: Temperature (0-1000)"  ,goalGraph.x,nextY);
  nextY += spacingY;
  fill(energyGraph.graphColor);
  text("y: Energy (0-1000)"    ,goalGraph.x,nextY);
  nextY += spacingY;
  fill(relayGraph.graphColor);
  text("y: Relay on/off (0-1)"    ,goalGraph.x,nextY);
  nextY += spacingY;
  fill(255);
  text("x: Time (0-"+goalGraph.numValues+")"         ,goalGraph.x,nextY);
  
  //int marker = (keyPressed && key == ' ')? 1 : 0;
  //println(marker);
  
  // logging data to file
  if(newData)
    output.println(goalGraph.numValues+"\t"+temp+"\t"+goal+"\t"+relay+"\t"+energy);
}
void keyPressed()
{
  if(key == 'r')
    reset();
}

void stop()
{
  stopRecordingToFile();
}

void reset()
{
  println("reset");
  energy = 0; 
  tempGraph.clear();
  goalGraph.clear();
  relayGraph.clear();
  energyGraph.clear();
  
  stopRecordingToFile();
  startRecordingToFile();
}

void startRecordingToFile()
{
  output = createWriter("data/logs/log "+getDate()+".txt");
  output.println("Log "+getDate());
  output.println("counter\ttemp\tgoal\trelay\tenergy");
}
void stopRecordingToFile()
{
  output.println("\n(Properly stopped)");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
}
String getDate()
{
  //return hour()+"."+minute()+"."+second()+" "+day()+"-"+month()+" "+year();
  return year()+"-"+month()+"-"+day()+" "+hour()+"."+minute()+"."+second();
}
