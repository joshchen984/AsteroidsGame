Spaceship ship;
Star[] stars;
boolean isLeft, isRight, isAccel;
int turnDeg;
int framerate;
int hyperCooldown;
ArrayList<Asteroid> asteroids;
ArrayList<Integer> indexes;
public void setup() 
{
  size(500,500);
  background(0);
  int col = color(100);
  asteroids= new ArrayList<Asteroid>();
  indexes = new ArrayList<Integer>();
  //add asteroids
  for(int i = 0; i < 10; i++){
    asteroids.add(new Asteroid(col));
  }

  //initializing ship variables
  col = color(100,255,105);
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
  Asteroid a;
  
  background(0);
  for(Star s:stars){
    s.show();
  }
  ship.move();
  ship.show(isAccel);
  //moving asteroids
  for(int i = 0; i < asteroids.size(); i++){
    a = asteroids.get(i);
    a.move();
    a.show();
    if (a.isOutofScreen()){
      indexes.add(i);
    }else if (a.isCollide(ship)){
      indexes.add(i);
    }
  }
  for(int i: indexes){
    asteroids.remove(i);
    int col = color(100);
    asteroids.add(new Asteroid(col));
  }
  indexes.clear();

  //moving ship
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
