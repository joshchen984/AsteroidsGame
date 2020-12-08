class Bullet extends Floater{
    public Bullet(Spaceship ship){
        myCenterX = ship.getX();
        myCenterY = ship.getY();
        myPointDirection = ship.getDirection();
    }
    void show(){
        fill(255,0,0);
        ellipse((float)myCenterX, (float)myCenterY,(float) 10,(float)10);
    }
    void move(){
        //change the x and y coordinates by myXspeed and myYspeed       
        myCenterX += myXspeed;    
        myCenterY += myYspeed;     
    }
    public boolean isOutofScreen(){
        if((myCenterX < 0) || (myCenterX > width)){
            return true;
        }
        if((myCenterY < 0) || (myCenterY > height)){
            return true;
        }
        return false;
    }

    public boolean isCollide(Asteroid a){
        double ax = a.getX();
        double ay = a.getY();
        double asize = a.getSize();
        if(dist((float)ax, (float)ay, (float)myCenterX, (float)myCenterY) < asize * 4 + 17){
            return true;
        }else{
            return false;
        }
    }
}