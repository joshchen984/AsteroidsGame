import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AsteroidsGame extends PApplet {

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
    ship.accelerate(0.5f);
  }
  if (hyperCooldown >0){
    hyperCooldown --;
  }
}
public void keyPressed(){
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

public void keyReleased(){
  if(key == 'd'){
    isRight = false;
  }else if(key == 'a'){
    isLeft = false;
  }else if(key == 'w'){
    isAccel = false;
  }
}
class Asteroid extends Floater{
    private int rotationSpeed;
    private int size, start;
    public Asteroid(int c){
        start = (int)(Math.random() * 4);
        corners = 5;
        myPointDirection = (int)(Math.random() * 360);
        myColor = c;
        xCorners = new int[corners];
        yCorners = new int[corners];
        size = (int)(Math.random() * 10) + 6;
        initPos();
        rotationSpeed = (int)(Math.random() * 6) + 1;
        createCorners();
    }
    
    public void move(){
        turn(rotationSpeed);
        //change the x and y coordinates by myXspeed and myYspeed       
        myCenterX += myXspeed;    
        myCenterY += myYspeed;   
    }
    private void createCorners(){
        createCorner(0,3,1);
        createCorner(1,-2,2);
        createCorner(2,-3,-2);
        createCorner(3,1,-4);
        createCorner(4,1,-2);
    }
    private void createCorner(int idx,int x, int y){
        xCorners[idx] = x * size;
        yCorners[idx] = y * size;
    }
    private void initPos(){
        //0 = left 1 = right 2 = down 3 = up
        switch (start){
            case 0:
                myCenterX = -size * 3;
                myCenterY = (int)(Math.random() * height);
                myYspeed = (Math.random() * 3) -1;
                myXspeed = (Math.random() * 1) + 1;
                break;
            case 1:
                myCenterX = width + size * 3;
                myCenterY = (int)(Math.random() * height);
                myYspeed = (Math.random() * 3) -1;
                myXspeed = - ((Math.random() * 1) + 1);
                break;
            case 2:
                myCenterY = height + size * 3;
                myCenterX = (int)(Math.random() * width);
                myXspeed = (Math.random() * 3) -1;
                myYspeed = - ((Math.random() * 1) +1);
                break;
            case 3:
                myCenterY = -size * 3;
                myCenterX = (int)(Math.random() * width);
                myXspeed = (Math.random() * 3) -1;
                myYspeed = (Math.random() * 1) +1;
                break;
        }
    }
    public boolean isOutofScreen(){
        if((myCenterX < -4 * size && start != 0) || (myCenterX > width + size * 4 && start !=1)){
            return true;
        }
        if((myCenterY < -4 * size && start !=3) || (myCenterY > height + size * 4 && start !=2)){
            return true;
        }
        return false;
    }

    public boolean isCollide(Spaceship ship){
        double shipx = ship.getX();
        double shipy = ship.getY();
        if(dist((float)shipx, (float)shipy, (float)myCenterX, (float)myCenterY) < size * 4 + 17){
            return true;
        }else{
            return false;
        }
    }
    public double getX(){
        return myCenterX;
    }
    public void setX(double x){
        myCenterX = x;
    }
    public double getY(){
        return myCenterY;
    }
    public void setY(double y){
        myCenterY = y;
    }
}
class Floater //Do NOT modify the Floater class! Make changes in the Spaceship class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myXspeed, myYspeed; //holds the speed of travel in the x and y directions   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myXspeed += ((dAmount) * Math.cos(dRadians));    
    myYspeed += ((dAmount) * Math.sin(dRadians));       
  }   
  public void turn (double degreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=degreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myXspeed and myYspeed       
    myCenterX += myXspeed;    
    myCenterY += myYspeed;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    } 
    
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    
    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()     
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    
    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);
    
    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);

    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
  }   
} 
class Spaceship extends Floater
{   
    public Spaceship(int c){
      corners = 4;
      myCenterX = width/2;
      myCenterY = height/2;
      myXspeed = 0;
      myYspeed = 0;
      myPointDirection = 0;
      myColor = c;
      xCorners = new int[corners];
      yCorners = new int[corners];
      
      createCorners();
    }
    public double getX(){
      return myCenterX;
    }
    public double getY(){
      return myCenterY;
    }
    public void move(){
      super.move();
      float decay = 0.05f;
      if (myXspeed > 0){
      myXspeed = Math.max(myXspeed - myXspeed * decay,0);
      }else{
        myXspeed = Math.min(myXspeed - myXspeed * decay,0);
      }
      
      if (myYspeed > 0){
      myYspeed = Math.max(myYspeed - myYspeed * decay,0);
      }else{
        myYspeed = Math.min(myYspeed - myYspeed * decay,0);
      }
    }
    public void hyperspace(){
      myXspeed = 0;
      myYspeed = 0;
      myPointDirection = (Math.random() * 360);
      myCenterX = Math.random() * width;
      myCenterY = Math.random() * height;
    }
    public void show(boolean accelerate){
      //translate the (x,y) center of the ship to the correct position
      translate((float)myCenterX, (float)myCenterY);
      //convert degrees to radians for rotate()     
      float dRadians = (float)(myPointDirection*(Math.PI/180));
      //rotate so that the polygon will be drawn in the correct direction
      rotate(dRadians);
      
      //creating boosters
      if (accelerate){
      stroke(255,0,0);
      fill(255,0,0);
      rect(-30,7,20,3);      
      rect(-30,0,20,3);      
      rect(-30,-7,20,3);      
      }
      
      fill(myColor);   
      stroke(myColor);    
      //draw the polygon
      beginShape();
      for (int nI = 0; nI < corners; nI++)
      {
        vertex(xCorners[nI], yCorners[nI]);
      }
      endShape(CLOSE);

      //"unrotate" and "untranslate" in reverse order
      rotate(-1*dRadians);
      translate(-1*(float)myCenterX, -1*(float)myCenterY);

    }
    private void createCorners(){
      xCorners[0] = 20;
      yCorners[0] = 0;
      xCorners[1] = -20;
      yCorners[1] = 15;
      xCorners[2] = -15;
      yCorners[2] = 0;
      xCorners[3] = -20;
      yCorners[3] = -15;

    }
    
    
}
class Star //note that this class does NOT extend Floater
{
  protected int x, y;
  protected int size, col;
  public Star(){
    col = color((int)(Math.random() * 255),(int)(Math.random() * 255),(int)(Math.random() * 255));
    x = (int)(Math.random() * width);
    y = (int)(Math.random() * height);
    size = (int)(Math.random() * 10);
  }
  
  public void show(){
    fill(col);
    stroke(col);
    ellipse(x, y, size, size);
  }
}
  public void settings() {  size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AsteroidsGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
