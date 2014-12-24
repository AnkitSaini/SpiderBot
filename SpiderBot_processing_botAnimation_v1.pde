import processing.serial.*;

int x=0, y=0;
byte data[] = {0,0,0}; // Array to send data to arduino
Serial myPort;

void setup()
{
  
  size(800, 500);
  strokeWeight(5);
  smooth();
}

void draw()
{


  String[] data = loadStrings("PATH_TO_TEXT_FILE");

  for (int i = 0; i<1; i++)
  {
    int current_x = 0, current_y = 0, old_x = 50, old_y = 50;
    //The bot animations quad
    fill(255, 255, 255);
    quad(50, 50, 450, 50, 450, 450, 50, 450);
    strokeWeight(1);
    stroke(255, 0, 0);
    for (int j = 1; j <= 10; j++)
    {
      // vertical lines
      current_x = 40 + old_x;
      line(current_x, 50, current_x, 450);
      old_x = current_x;

      //horizontal lines
      current_y = 40 + old_y;
      line(50, current_y, 450, current_y);
      old_y = current_y;
    }
    
    
    String[] dataValues = split(data[i], ",");
    int rect_x = parseInt(dataValues[0]);
    int rect_y = parseInt(dataValues[1]);

    x = 70 + (rect_x - 1)*40;
    y = 70 + (rect_y - 1)*40;

    stroke(0);
    strokeWeight(5);
    line(50, 50, x, y);
    stroke(0);
    line(450, 450, x, y); 
    stroke(0);
    line(50, 450, x, y); 
    stroke(0);
    line(450, 50, x, y); 

    line(50, 50, x, y);
    stroke(0);
    line(450, 450, x, y); 
    stroke(0);
    line(50, 450, x, y); 
    stroke(0);
    line(450, 50, x, y); 

    // To fill color in the animation
    if (dataValues[2].equals("red") == true) {
      fill(255, 0, 0);
    }
    if (dataValues[2].equals("green") == true) {
      fill(0, 255, 0);
    }
    if (dataValues[2].equals("yellow") == true) {
      fill(255, 255, 0);
    }
    if (dataValues[2].equals("blue") == true) {
      fill(0, 0, 255);
    }
    quad(450, 50, 650, 50, 650, 450, 450, 450);
    
   
    if (dataValues[2].equals("red") == true) {
     fill(255,0,0);
    }
    if (dataValues[2].equals("green") == true) {
      fill(0, 255, 0);
    }
    if (dataValues[2].equals("yellow") == true) {
      fill(255, 255, 0);
    }
    if (dataValues[2].equals("blue") == true) {
      fill(0, 0, 255);
    }
    
    delay(100);
   
  }
}

