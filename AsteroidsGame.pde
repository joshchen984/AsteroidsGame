Spaceship ship;
Star[] stars;
boolean isLeft, isRight, isAccel;
int turnDeg;
int framerate;
int hyperCooldown;
public void setup() 
{
  size(500,500);
  background(0);
  
  //initializing ship variables
  int col = color(100,255,105);
  isLeft = false;
  isRight = false;
  isAccel = false;
  turnDeg = 6; //how much ship turns after pressing key
  ship = new Spaceship(col);
  
  stars  = new Star[70];
  for(int i = 0; i < stars.length;i++){
    stars[i] = new Star();
  }
  hyperCooldown = 0;
  framerate = 60;
  frameRate(framerate);
}
public void draw() 
{
  background(0);
  for(Star s:stars){
    s.show();
  }
  ship.move();
  ship.show(isAccel);
  
  if (isLeft){
    ship.turn(-turnDeg);
  }else if (isRight){
    ship.turn(turnDeg);
  }
  if (isAccel){
    ship.accelerate(0.5);
  }
  if (hyperCooldown >0){
    hyperCooldown --;
  }
}
void keyPressed(){
  if(key == 'd'){
    isRight = true;
  }else if(key == 'w'){
    isAccel = true;
  }else if(key == 'a'){
    isLeft = true;
  }else if (key == ' ' && hyperCooldown <=0){
    ship.hyperspace();
    hyperCooldown = framerate * 10; //10 second cooldown
  }
}

void keyReleased(){
  if(key == 'd'){
    isRight = false;
  }else if(key == 'a'){
    isLeft = false;
  }else if(key == 'w'){
    isAccel = false;
  }
}
