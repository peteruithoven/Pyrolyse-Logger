void setup()
{
  println("day: "+day());
  println("hour: "+hour());
  println("millis: "+millis());
  println("minute: "+minute());
  println("month: "+month());
  println("second: "+second());
  println("year: "+year());  
  
  println(getDate());
}

void draw() 
{
  
}
String getDate()
{
  //return hour()+"."+minute()+"."+second()+" "+day()+"-"+month()+" "+year();
  return year()+"-"+month()+"-"+day()+" "+hour()+"."+minute()+"."+second();
}
