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
