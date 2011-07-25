import processing.opengl.*;

boolean debug=false;
PImage jew[]=new PImage[210];
PImage flare,backi;

int xw=10, yw=10;
jewel[][] level=new jewel[xw][yw+3];
PFont font;
anim_queye anims = new anim_queye();
score_board score=new score_board();
boolean dropping=false,dropping_was;

void setup(){
  size(640,640,OPENGL);
  noStroke();
 // hint(DISABLE_OPENGL_2X_SMOOTH);
  font=loadFont("f2.vlw");
  textFont(font);
  PImage jewelit=loadImage("jewels.png");
  for (int y=0;y<14;y++)
    for (int x=0;x<15;x++){
      int i=y*15+x;
      jew[i]=createImage(52,52,ARGB);
      jew[i].copy(jewelit,x*52,y*52,52,52,0,0,52,52);
    }
  backi=loadImage("back.jpg");
  flare=loadImage("ball.png");
  frameRate(60);
  
  for(int i=0;i<xw;i++)
  for(int j=0;j<yw+2;j++)
    level[i][j]=null;
  jewel laita=new jewel(-1,-1,9);
  for(int i=0;i<xw;i++)
  {
    level[i][yw+1]=laita;
    level[i][yw+2]=laita;
  }
  //show_level();
}
int a=0; // animation
jewel j;
jewel mpo=null,ex_mpo=null;

void draw(){
  //background(0);
  tint(100,200);
  image(backi,1,1);
  // === Frames Per Second ===
  //fill(255);text("fps="+floor(frameRate),0,630);
  a=(a+1)%15;
  dropping=false;
  for(int y=0;y<=yw;y++)
    for(int x=0;x<xw;x++){
    j=level[x][y];
    if (j!=null){

    //j=jews[i];
    tint(255, 255);
    if (
      mouseX>j.x && mouseX<j.x+52 && 
      mouseY>j.y && mouseY<j.y+52 
      ) {
      //blend(jew,a*52,52*2*j.type,52,52,(int)(j.x+j.xx),(int)(j.y+j.yy),52,52,ADD);
      image(jew[j.type*30+a],(int)(j.x+j.xx),(int)(j.y+j.yy),52,52);
      if (mousePressed) {
        mpo=j;
        if (ex_mpo!=null && mpo!=ex_mpo && mpo.state==0 && ex_mpo.state==0) j._switch(ex_mpo);
        ex_mpo=mpo;
      }else {mpo=null;ex_mpo=null;}
      if (debug){
        text(j.state,mouseX,mouseY);
      }
    }
    else image(jew[j.type*30],(int)(j.x+j.xx),(int)(j.y+j.yy),52,52);
//    blend(jew,52,52*2*j.type,52,52,(int)(j.x+j.xx),(int)(j.y+j.yy),52,52,ADD);
    //copy(jew,a*52,52*2*j.type,52,52,(int)j.x,(int)j.y,52,52);
    j.tick();
    if (debug){
      fill(0);
      text(j.type(),x*52+23,y*52+35);
      fill(255);
      text(j.type(),x*52+21,y*52+33);
      if (j.state==3) text("SWITCHEROO",0,20);
    }
    if (j.type()==8) dropping=true;
  }}
  anims.tick();
  fill(0);
  rect(0,0,640,50);
  fill(255);
  text("Last combo: "+score.count_combo+" "+score.last_combo+" Best "+score.best_combo,0,40);
  //if (a==0) 
  for(int i=0;i<xw;i++){
    if (level[i][0]==null&&level[i][1]==null){
      j=new jewel(i,0,round(random(0,2))); // different jewels
      j.x=i*52;
      j.y=0;
      j.state=DROPPING;
      dropping=true;
      //j.tick();
      level[i][0]=j;
      //break;
    }
  }
  dropping_was=dropping;
  delay(10);
}
Vector same=new Vector();
boolean check_level(){
 int was=99;
 boolean something_happened=false;
 same.clear();
 for(int y=0;y<=yw;y++){
   for(int x=0;x<xw;x++)if (level[x][y]!=null){
     if ((level[x][y].type()==was || was==99)&& was!=8 ) same.add(new Point(x,y));
     else {
       if (was<8 && same.size()>2){
         kill_same();
         something_happened=true;
       }
       same.clear();
       same.add(new Point(x,y));
     }
     was=level[x][y].type();
   }else{
     was=-1;
   }
   if (same.size()>2) {
     kill_same();
     something_happened=true;
   }
   same.clear();
 }
 
 // and vertical
 for(int x=0;x<xw;x++){
   for(int y=0;y<=yw;y++)if (level[x][y]!=null){
     if ((level[x][y].type()==was || was==99)&& was!=8 ) same.add(new Point(x,y));
     else {
       if (was<8 && same.size()>2){
         kill_same();
         something_happened=true;
       }
       same.clear();
       same.add(new Point(x,y));
     }
     was=level[x][y].type();
   }else{
     was=-1;
   }
   if (same.size()>2) {
     kill_same();
     something_happened=true;
   }
   same.clear();
 }

 if (something_happened){
   for(int y=0;y<=yw;y++)
     for(int x=0;x<xw;x++){
       if (level[x][y]!=null &&
           level[x][y].kill_switch){
         anims.add(x*52+26,y*52+26,FLARE_EFFECT,level[x][y].switch_phase,(Object)level[x][y]);
         level[x][y]=null;
       }
     }
 }

 return something_happened;
 //System.out.println("level checked");
}
void kill_same(){
   int how_many=same.size();
   for(int i=0;i<how_many;i++){
     Point del=(Point)same.get(i);
     level[del.x][del.y].kill_switch=true;
     level[del.x][del.y].switch_phase=how_many;
     //System.out.println("removed "+del.x+","+del.y+"  "+was); 
   }
   if (dropping_was) score.add_combo();
   else score.clear_combo();
}
int lev(int x,int y){
  if (x>=xw || x<0 || y>=yw||y<0)return 9;
  return level[x][y].type();
}
class Point{
  int x,y;
  Point(int xi,int yi){
    x=xi; y=yi;
  }
}
