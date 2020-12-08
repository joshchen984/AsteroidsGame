Spaceship ship;
Star[] stars;
boolean isLeft, isRight, isAccel, isShooting;
int turnDeg;
int framerate, score;
int hyperCooldown, bulletCooldown;
ArrayList<Asteroid> asteroids;
ArrayList<Integer> astIndexes;
ArrayList<Integer> bulIndexes;
ArrayList<Bullet> bullets;
public void setup() 
{
  size(500,500);
  background(0);
  int col = color(100);
  asteroids= new ArrayList<Asteroid>();
  astIndexes = new ArrayList<Integer>();
  bulIndexes = new ArrayList<Integer>();
  bullets = new ArrayList<Bullet>();
  //add asteroids
  for(int i = 0; i < 8; i++){
    asteroids.add(new Asteroid(col));
  }

  //initializing ship variables
  col = color(100,255,105);
  isLeft = false;
  isRight = false;
  isAccel = false;
  isShooting = false;
  turnDeg = 6; //how much ship turns after pressing key
  ship = new Spaceship(col);
  
  stars  = new Star[70];
  for(int i = 0; i < stars.length;i++){
    stars[i] = new Star();
  }
  hyperCooldown = 0;
  bulletCooldown = 0;
  framerate = 60;
  score = 0;
  frameRate(framerate);
}

public void gameOver(){
  fill(255);
  noLoop();
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width/2, height/2);
}
public void drawScore(){
  fill(255);
  textAlign(LEFT);
  textSize(25);
  text(score, 0, 25);
}
public void draw() 
{
  Asteroid a;
  Bullet b;
  background(0);
  drawScore();

  for(Star s:stars){
    s.show();
  }
  ship.move();
  ship.show(isAccel);
  //moving asteroids
  for(int i = asteroids.size() - 1; i >=0; i--){
    a = asteroids.get(i);
    a.move();
    a.show();
    if (a.isOutofScreen()){
      astIndexes.add(i);
    }else if (a.isCollide(ship)){
      gameOver();
    }
  }
  //removing asteroids
  for(int i: astIndexes){
    asteroids.remove(i);
    int col = color(100);
    asteroids.add(new Asteroid(col));
  }
  astIndexes.clear();
  //moving bullets
  for(int i = bullets.size() - 1; i >=0;i--){
    b = bullets.get(i);
    b.move();
    b.show();
    if(b.isOutofScreen()){
      bulIndexes.add(i);
    }else{
      // looping through asteroids to check for collision
      for(int j = 0; j < asteroids.size();j++){
        if(b.isCollide(asteroids.get(j))){
          bulIndexes.add(i);
          astIndexes.add(j);
          score+=20;
          break;
        }
      }
    }
  }
  //removing bullets
  for(int i: bulIndexes){
    bullets.remove(i);
  }
  bulIndexes.clear();
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
  if(bulletCooldown > 0){
    bulletCooldown--;
  }
  if(isShooting && bulletCooldown <=0){
    bullets.add(new Bullet(ship));
    bullets.get(bullets.size() - 1).accelerate(6);
    bulletCooldown = framerate /3;
  }
  score++;
}
void keyPressed(){
  if(key == 'd'){
    isRight = true;
  }else if(key == 'w'){
    isAccel = true;
  }else if(key == 'a'){
    isLeft = true;
  }else if (key == 'q' && hyperCooldown <=0){
    ship.hyperspace();
    hyperCooldown = framerate * 10; //10 second cooldown
  }else if (key == ' '){
    isShooting = true;
  }
}

void keyReleased(){
  if(key == 'd'){
    isRight = false;
  }else if(key == 'a'){
    isLeft = false;
  }else if(key == 'w'){
    isAccel = false;
  }else if(key == ' '){
    isShooting = false;
  }
}
