/**
 * Graph
 */
class SimpleLineGraph
{
  // public
  int x = 0;
  int y = 0;
  int graphWidth = 500;
  int graphHeight = 500;
  int graphColor = #0066ff;
  int maxValue = 100;
  boolean autoScaleY = false;
  
  // private
  int zeroX;
  int zeroY;
  int stepX;
  int[] values = new int[0];
  int numValues = 0;
  int highestValue = -9999;
  
  SimpleLineGraph()
  {
    
  }
  
  void draw()
  {
    stroke(255);
    line(x,y,x,y+graphHeight);
    line(x,y+graphHeight,x+graphWidth,y+graphHeight);
    
    stroke(graphColor);
    zeroX = x;
    zeroY = y+graphHeight;
    stepX = int(float(graphWidth)/float(numValues));
    println("stepX: "+stepX);
    
    int nextX = zeroX;
    int nextY = zeroY;
    int prevX = nextX;
    int prevY = nextY;
    for(int i=0;i<numValues;i++)
    {
      int value = values[i];
      nextX = zeroX+stepX*(i+1);
      
      if(autoScaleY)
        nextY = int(zeroY - float(value)/float(highestValue)*float(graphHeight));
      else
        nextY = int(zeroY - float(value)/float(maxValue)*float(graphHeight));
      //nextY = round(float(nextY)/float(maxValue)*float(highestValue)); 
      
      line(prevX,prevY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
  }
  
  void appendValue(int value)
  {
    values = append(values, value);
    numValues++;
    if(value > highestValue) highestValue = value; 
    
    //println(values);
    print(" numValues: "+numValues);
  }
}
