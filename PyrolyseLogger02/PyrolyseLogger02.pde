/**
 * ToDo:
 * Add markers to logfile
 * Accurate time
 */
Main main;

void setup() 
{
  // config
  size(700,700);
  frameRate(10);
  //frameRate(1);
  smooth();
  
  main = new Main(this);
}
void draw()
{
  main.draw();
}
void keyPressed()
{
  main.keyPressed();
}
void stop()
{
  main.stop(); 
}

