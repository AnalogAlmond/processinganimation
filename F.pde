float x = 0;//grid's line end point coordinates
float y = 0;
float rx = 0;//grid's x rotation
float spacing = 195.14; //spacing in between grid lines
float ty = 0;//grid's y offset
float tya = 400;//secondary grid's initial y offset
float scale = 2;//concentric circle scale
float cx = -200;//concentric circle coordinates
float cy = -200;
float angle = 0;//whole screen z rotation angle
float radius = 230;//radius of circle around which concentric circles rotate
float alpha = 0;//angle of concentric circle's rotation
float weight = 8;//concentric circle's line weight
float ls = 0;//line start point
float[] size = {75,150,225,300,375};//radii of concentric circles
float[] dx = {0,0,0,0,0};//coordinates of circles
float[] dy = {0,0,0,0,0};
float tside = 30;//length of equilateral triangle's side
float desc = 30;//amount of descension for equilateral triangle
float[] triangle = {0,0,0,0,0,0};//equilateral triangle coordinates
float offset = 0;

PFont font;
int bgr = 0;//background colors in rgb
int bgg = 20;
int bgb = 0;

void setup() {
  size(1366, 768,P3D);//monitor size
  background(bgr,bgg,bgb);
  noFill();//doesn't fill in shapes
  stroke(32,194,14);//line color
  strokeWeight(8);//line thickness
  smooth();
  font = createFont("RussoOne-Regular.ttf",90);
  frameRate(30);
}

void grid(float x, float y, float tx, float ty, float rx, float ry, float rz){
    pushMatrix();
    translate(tx,ty);//shifts grid in space
    rotateX(rx);//rotates grid toward/away from the viewer
    rotateY(ry);//rotates grid to the right/left
    rotateZ(rz);//rotates grid around the screen plane
    
    //draws lines that make up grid
    for(float i = 0; i <= width*2; i+=spacing){
      line(i,0,i,x);
    }
    for(float i = 0; i <= height*2+spacing; i+=spacing){
      line(0,i,y,i);
    }
    ty++;
    popMatrix();
}

void conc(float x, float y, float scale,float weight){
  pushStyle();//ensures that stroke weight only changes for this object
  strokeWeight(weight);
  int step = 50;//spacing between circles
  int start = 50;//size of smallest circle
  //draws 5 concentric circles
  for(int i = 0; i < 5; i++){
    ellipse(x,y,(start+step*i)*scale,(start+step*i)*scale);
  }
  popStyle();
}


void draw(){
  background(bgr,bgg,bgb);//refreshes bg every frame
  //DRAW GRID
  if(x<=height || y<=width){
    grid(x,y,0,0,0,0,0);
    if(x<=height)x+=height/5/2.5;
    if(y<=width)y+=width/5/2.5;
    
    //initializing some values
    offset = height/10.24;
    ls = -width/4;
    ty = -height / 2;
    for(int i = 0; i < 5; i++){
      dx[i]=width/2;
      dy[i]=height/2;
    }
  }
  else if(x>=height && y>=width){
    pushMatrix();
    translate(width/2,height/2);
    //BEGIN GRID ROTATION
    rotateZ(radians(angle));
    if(angle>=-360){
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      angle -= 360.0/36/3;
      //AT ANGLE = -150, DRAW SECONDARY GRID
      if(angle<=-150){
        grid(height*2,width*2,width/2,-ty-tya,-rx,0,radians(180));
        if(tya>=0) tya-=400/8/2.5;//makes secondadry grid rise from tya offscreen  
      }
      if(ty<=height/3) ty+=(height/2+height/3)/8/2.5;
      if(rx<=PI/3) rx+=PI/3/6/2.5;
    }
    else{//after a full rotation is completed, make grids rise
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      grid(height*2,width*2,width/2,-ty,-rx,0,radians(180));
      if(ty>=0) ty-=height/3/8/2.0;
      if(rx <= PI/2) rx+=(PI/2-PI/3)/8/2.0;
    }
     popMatrix();
     
    //INITIAL LINEAR CIRCLE MOVEMENT
    if((cy<=height/2+radius)&&(cx<=width/2)){//initial linear movement phase
      conc(cx,cy,scale,weight);
      cy+=(height/2+radius)/14/2.5;
      cx+=(width/2)/14/2.5;
    }
   else{
      //CIRCLE ROTATION
      conc(width/2+sin(alpha)*radius,height/2+cos(alpha)*radius,scale,weight);
      if(radius>0) radius-=230/25/2.5;
      if(alpha<2*PI)alpha+=radians(360.0/18/3);
    }
    if((scale>=1)&&(angle>-360))scale-=1.0/30/2.5;//gradually shrinks circles
    //AT ANGLE = -270, ENLARGE CONCENTRIC CIRCLES' THICKNESS
    if((angle<=-270)&&(angle>=-360)){
      if(weight<50)weight+=42.0/12/2;
    }
  }
  
  if(angle<=-360){
    //DRAWS LINE INSTEAD OF MERGED GRIDS AND SHRINKS IT INTO CIRCLE
    if(rx >= PI/2){
      background(bgr,bgg,bgb);
      conc(width/2,height/2,scale,weight);
      line(ls,height/2,width-ls,height/2);
      if((ls <= width/2-100)) ls+=(width/2+width/4)/7/2;
      else ls = width/2;
      if(ls >= 0){//returns normal weight and scale
        if(scale<=1.5)scale+=0.5/8/2.5;
        if(weight>=8)weight-=42.0/8/2.5;
      }
    }
    
    if(weight<=8){
      background(bgr,bgg,bgb);
      for(int i = 0; i < 5; i++){
        ellipse(dx[i],dy[i],size[i],size[i]);
      }
      //ENLARGE AND SPLIT CIRCLES
      for(int i = 0; i < 5; i++){
        if((size[i] < 400) && (dx[1] <= 3 * width / 4 - offset)) size[i] += (5-i)*4;//makes sure they all grow in proportional speeds
      }
        if(dx[1] <= 3*width/4-offset)   dx[1]+=(((3*width/4-offset)-width/2)/8.0)*4/10;//upper right
        if(dy[1] >= height/4+offset)    dy[1]-=(height/4+offset+height/2)/8/10;
        if(dx[2] >= width/4+offset)     dx[2]-=((width/4+offset)+(width/2))/8/10;//upper left
        if(dy[2] >= height/4+offset)    dy[2]-=((height/4+offset)+(height/2))/8/10;
        if(dx[3] <= 3*width/4-offset)   dx[3]+=((3*width/4-offset)-width/2)/8.0*4/10;//lower right
        if(dy[3] <= 3*height/4-offset)  dy[3]+=((3*height/4-offset)-height/2)/8.0*4/10;
        if(dx[4] >= width/4+offset)     dx[4]-=(width/4+offset+width/2)/8/10;//lower left
        if(dy[4] <= 3*height/4-offset)  dy[4]+=((3*height/4-offset)-(height/2))/8.0*4/10;
    }
    
    if(dx[1]>=(3*width/4.0-offset)){//after the circles have been split
      for(int i = 0; i < 5; i++){
        ellipse(dx[i],dy[i],size[i],size[i]);
      }
      for(int i = 0; i < 5; i++){
        if(size[i]>100)size[i]-=300.0/12/2.5;//shrinks the circles
      }
      //TRIANGLE
      if(size[0]<300){
        triangle(width/2 + triangle[0],height/2+triangle[1]+desc,width/2+triangle[2],height/2+triangle[3]+desc,width/2+triangle[4],height/2+triangle[5]+desc);
        triangle[1] = sqrt(pow(tside,2)-pow(tside/2,2))/2;
        triangle[2] = -tside/2;
        triangle[3] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
        triangle[4] = tside/2;
        triangle[5] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
        if(tside <= 230) tside+=200/8/2.5;
        //WELCOME
        if(tside >= 220){
          pushStyle();
          textSize(100);
          fill(32,194,14);
          textAlign(CENTER);
          textFont(font);
          text("WELCOME",width/2,150);
          popStyle();
        }
      }
    }
  }
  //saveFrame("#######.png");
}
