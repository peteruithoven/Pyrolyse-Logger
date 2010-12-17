SimpleLineGraph graph;

void setup() 
{
  size(700,700);
  frameRate(5);
  smooth();
  
  graph = new SimpleLineGraph();
  graph.x = 100;
  graph.y = 100;
  graph.autoScaleY = true;
  
  graph.appendValue(0);
}
void draw() 
{
  background(0);
  
  graph.appendValue(round(random(0,110)));
  graph.draw();
}

