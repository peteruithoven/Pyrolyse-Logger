class Main implements SerialComListener
{ 
  int temp;
  int goal;
  int relay;
  int energy;
  int energyCostPerSecond = 20;
  Boolean newData = false;
  
  SimpleLineGraph goalGraph;
  SimpleLineGraph relayGraph;
  SimpleLineGraph energyGraph;
  SimpleLineGraph tempGraph;
  
  SerialCommunicator serialCom;
  int prevReadTime = 0;
  int interval = 1000;
  
  PFont font;
  PrintWriter output;
  int counter = 0;
  
  Main(PApplet applet)
  {   
    // connection
    serialCom = new SerialCommunicator(applet,this);
    
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
  
  void newMessage(int[] message,int messageLength)
  {
    print("newMessage: ("+messageLength+")");
    
    newData = true;
    
    for(int i=0;i<messageLength;i++)
    {
      switch(byte(message[i]))
      {
        case 'c':
          temp = message[(i+1)];
          temp = int(float(temp)/float(255)*1000);
          tempGraph.appendValue(temp);
          print(" C: "+temp+", ");
          break;
        case 'g':
          goal = message[(i+1)];
          goal = int(float(goal)/float(255)*1000);
          goalGraph.appendValue(goal);
          print("G: "+goal+", ");
          break;
        case 's':
          relay = message[(i+1)]-1;
          relayGraph.appendValue(relay);
          if(relay == 1)
            energy += energyCostPerSecond;
          print("S: "+relay+", ");
          energyGraph.appendValue(energy);
          break;
        case 'r':
          println(" R");
          reset();
          break;
      }
    } 
    println(" ");
  }
  
  void draw() 
  { 
    /*if(millis() > prevReadTime+interval)
    {
      serialCom.sendRequest();
      prevReadTime = millis();
    }*/
    serialCom.update();
    
    if(keyPressed && key == 'd')
    {
      //counter++;
      //if(counter <= 10)
      temp = round(random(0,1000));
      tempGraph.appendValue(temp);
      goal = round(random(0,1000));
      goalGraph.appendValue(goal);
      relay = round(random(0,1000));
      relayGraph.appendValue(relay);
      energy = round(random(0,5000));
      energyGraph.appendValue(energy);
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
    text("y: Goal (0 - 1000)"         ,goalGraph.x,nextY);
    nextY += spacingY;
    fill(tempGraph.graphColor);
    text("y: Temperature (0 - 1000)"  ,goalGraph.x,nextY);
    nextY += spacingY;
    fill(energyGraph.graphColor);
    text("y: Energy (0 - "+energyGraph.highestValue+")"    ,goalGraph.x,nextY);
    nextY += spacingY;
    fill(relayGraph.graphColor);
    text("y: Relay on/off (0 - 1)"    ,goalGraph.x,nextY);
    nextY += spacingY;
    fill(255);
    text("x: Time (0 - "+goalGraph.numValues+")"         ,goalGraph.x,nextY);
    
    //int marker = (keyPressed && key == ' ')? 1 : 0;
    //println(marker);
    
    // logging data to file
    if(newData)
      output.println(goalGraph.numValues+"\t"+temp+"\t"+goal+"\t"+relay+"\t"+energy);
      
    newData = false;
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
  
}
