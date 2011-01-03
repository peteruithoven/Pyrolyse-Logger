/**
 * SerialCommunicator
 */
class SerialCommunicator
{
  
  import processing.serial.*;

  // public
  int[] message = new int[0];
  int numMessageParts = 0;
  int[] messageBuffer = new int[0];
  int numMessageBufferParts = 0;
  Boolean commStarted = false;
  
  // private
  Serial myPort;
  SerialComListener listener;
  
  SerialCommunicator(PApplet applet,SerialComListener newListener)
  {
    // connection
    String portName = Serial.list()[0];
    myPort = new Serial(applet, portName, 9600);
    //println(Serial.list());
    
    listener = newListener;
  }
  
  void update()
  {
    read();
    //sendRequest();
  }
  void read()
  {
    //print("Reading: ");
    // if we've got new bytes
    if(myPort.available() > 0)
    {
      commStarted = true;
      //print("New data: ");
      //print(" ("+myPort.available()+") ");
      
      // we wil keep reading until nothing is left
      while(myPort.available() > 0)
      {
        int newByte = myPort.read();
        //print(newByte+((myPort.available()>0)?", ":""));
        
        //messageBuffer += newByte;
        
        // if we find the splitter we put all the buffered messages 
        //   in the final message, stop listening for more data and 
        //   notify a possible listener
        // else we just keep filling the buffer with incoming bytes. 
        
        if(newByte == '|')
        { 
          //println(" ");
          
          message = messageBuffer;
          numMessageParts = numMessageBufferParts;
          messageBuffer = new int[0];
          numMessageBufferParts = 0;
          
          listener.newMessage(message,numMessageParts);
        }
        else
        {
          messageBuffer = append(messageBuffer, newByte);
          numMessageBufferParts++;
        }
      }
      /*println(" ");
      print(" b: ");
      for(int i = 0; i < numMessageBufferParts; i++)
        print(messageBuffer[i]+",");
      print(" m: ");
      for(int i = 0; i < numMessageParts; i++)
        print(message[i]+",");*/
    }
    //println(" ");
  }
  void sendRequest()
  {
    if(commStarted)
      myPort.write('r');
  }
}


interface SerialComListener
{
  void newMessage(int[] message,int messageLength);
}
