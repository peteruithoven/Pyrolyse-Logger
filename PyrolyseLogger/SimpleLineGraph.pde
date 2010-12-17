/**
 * SimpleLineGraph
 */
class SimpleLineGraph
{
  float x = 0;
  float y = 0;
  float graphWidth = 500;
  float graphHeight = 500;
  int graphColor = #0066ff;
  int maxValue = 100;
  
  float zeroX;
  float zeroY;
  float stepX;
  int[] values = new int[0];
  int numValues = 0;

  SimpleLineGraph()
  {
    
  }
  
  void draw()
  {
    stroke(255,125);
    line(x,y,x,y+graphHeight);
    line(x,y+graphHeight,x+graphWidth,y+graphHeight);
    
    stroke(graphColor);
    zeroX = x;
    zeroY = y+graphHeight;
    stepX = graphWidth/(numValues-1);
    
    float nextX = zeroX;
    float nextY = zeroY;
    float prevX = nextX;
    float prevY = nextY;
    for(int i=0;i<numValues;i++)
    {
      int value = values[i];
      nextX = zeroX+stepX*i;
      
      nextY = zeroY - value/float(maxValue)*graphHeight;
      if(i != 0)
        line(prevX,prevY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
  }
  
  void appendValue(int value)
  {
    values = append(values, value);
    numValues++;
    //println(values);
    //print(" numValues: "+numValues);
  }
  void clear()
  {
    values = new int[0];
    numValues = 0;
  }
}
