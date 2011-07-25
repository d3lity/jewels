// states
final int STATIONARY=0,DROPPING=1,SWITCHING=2,SWITCHEROO=3,UNMOVABLE=4;

class jewel{
  float x,y,xx,yy,xc,yc,drop_yy;
  int xi,yi;
  int switch_phase;
  int type;
  int state;
  boolean checked;
  boolean kill_switch;
  jewel switch_to;
  
  jewel(int xs,int ys,int types){
    xi=xs;yi=ys;
    type=types;
    x=xi*52;
    y=yi*52;
    xx=0;
    yy=0;
    drop_yy=0;
    state=STATIONARY;
    kill_switch=false;
    if (types==9) state=UNMOVABLE;
  }
  int type(){
    if (state==DROPPING) return 8;
    else return type;
  }
  void tick(){
    if (state==UNMOVABLE) return;
    if ((state==STATIONARY || state==SWITCHEROO) && level[xi][yi+1]==null) {
      state=DROPPING;
      drop_yy=0;
      xx=0;
      yy=0;
    }
    if (state==SWITCHEROO) {
      xc++;
      if (xc>10) {
        state=STATIONARY;
        xx=0;yy=0;
      }
      return;
    }

    if (state==STATIONARY){
      x=xi*52;
      y=yi*52;
      xx=0;
      yy=0;
    }
    if (state==DROPPING) {
      drop_yy+=1;
      if (drop_yy>50) drop_yy=50; //max dropping speed
      yy=yy+drop_yy;
      if (yy>0){
        if (level[xi][yi+1]==null){
          level[xi][yi+1]=this;
          level[xi][yi]=null;
          yi=yi+1;
          y=yi*52;
          yy-=52;
        }else{
          yy=0;
          state=STATIONARY;
          check_level();
          //check here
        }
      }
    }
    if (state==SWITCHING){
      switch_phase+=20;
      xx=-xc*sin(radians(switch_phase));
      yy=-yc*sin(radians(switch_phase));

      switch_to.xx=xc*sin(radians(switch_phase));
      switch_to.yy=yc*sin(radians(switch_phase));

      if (switch_phase>=90 && !checked){
       //level[xi][yi]=switch_to.type+1;
       //level[switch_to.xi][switch_to.yi]=type+1;
       level[xi][yi]=switch_to;
       level[switch_to.xi][switch_to.yi]=this;
       if (!check_level()){
         level[xi][yi]=this;
         level[switch_to.xi][switch_to.yi]=switch_to;         
       }else{

         yy=0;xx=0;
         int xiw=xi,yiw=yi;
         yi=switch_to.yi;xi=switch_to.xi;
         y=switch_to.y;x=switch_to.x;
         state=STATIONARY;

         switch_to.xx=0;switch_to.yy=0;
         switch_to.xi=xiw;switch_to.yi=yiw;
         switch_to.x=xiw*52;switch_to.y=yiw*52;
         switch_to.state=STATIONARY;
       }
       //if (check_hits(xi,yi,switch_to.type,false)) check_hits(xi,yi,switch_to.type,true);
//       if (check_hits(switch_to.xi,switch_to.yi,switch_to.type,false)) check_hits(switch_to.xi,switch_to.yi,type,true);
       //show_level();
        checked=true;
      }

      if (switch_phase>=180) {
       //level[xi][yi]=type+1;
       //level[switch_to.xi][switch_to.yi]=switch_to.type+1;
        state=STATIONARY;
        switch_to.state=STATIONARY;
      }
    }
  }
  void _switch(jewel j){
    j.checked=false;
    j.xc=0;j.yc=0;
    if (j.x>x) j.xc=52;
    if (j.x<x) j.xc=-52;
    if (j.y>y) j.yc=52;
    if (j.y<y) j.yc=-52;
    j.switch_phase=0;
    j.state=SWITCHING;
    j.switch_to=this;
    state=SWITCHEROO;
    xc=0;
    //System.out.println("  xi "+  xi+"  yi "+yi);
    //System.out.println(" jxi "+j.xi+" jyi "+j.yi);
  }
}
