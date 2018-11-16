class star {
  float x, y, speed, d, age,sizeIncr,xi,yi;
  int wachsen;
  star() {
    x = random(width);
    y = random(height);
    speed = random(0.2, 5);
    wachsen= int(random(0, 2));
    if(wachsen==1)d = 0;
    else {
      d= random(0.2, 3);
    }
    age=0;
    sizeIncr= random(0,0.03);
  }
  void render() {
   age++;
     if (age<200){
       if (wachsen==1){
         d+=sizeIncr;
         if (d>3||d<-3) d=3;
       }else {
         if (d>3||d<-3) d=3;
         d= d+0.2-0.6*noise(x, y, frameCount);
       }
       
 
     }
     else{
       if (d>3||d<-3) d=3;
     }
    
    ellipse(x-400, yy+y, d*(map(noise(x, y,0.001*frameCount),0,1,0.2,1.5)), d*(map(noise(x, y,0.001*frameCount),0,1,0.2,1.5)));
  }
  void move() {
      
      xi=width/2;
      yi=height/2+20;
    
    x =x-map(xi, 0, width, -0.05*speed, 0.05*speed)*(w2-x); 
    y =y-map(yi, 0, height, -0.05*speed, 0.05*speed)*(h2-y);
  }
}

star neuerStern;
int yy;

ArrayList<star> starArray = new ArrayList<star>();
float h2;//=height/2
float w2;//=width/2
float d2;//=diagonal/2
int numberOfStars = 2000;
int newStars =50;

void starSetup() {
  w2=width;
  h2= height;
  d2 = dist(-h2, -w2, w2, h2);
  neuerStern= new star();
}
void starDraw(int ypos) {
  yy=ypos;
  fill(255);
  //fill(0,10);
  neuerStern.render();
  for (int i = 0; i<newStars; i++) {   // star init
    starArray.add(new star());
  }


  for (int i = 0; i<starArray.size(); i++) {
    if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i);
    starArray.get(i).move();
    starArray.get(i).render();
  }
  if (starArray.size()>numberOfStars) {//
    for (int i = 0; i<newStars; i++) {
      starArray.remove(i);
    }
  }
}