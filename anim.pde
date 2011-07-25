final int 
  FLARE_EFFECT=1,
  SCORE=2;
class anim{
  float x,y,xx,yy;
  int ttl;
  int frame;
  int loops;
  int type,type_modifier;
  Object obj;
  boolean kill_me=false;
  anim(float x,float y,int type){
    params(x,y,type,0,null);
  }
  anim(float x,float y,int type,int type_modifier){
    params(x,y,type,type_modifier,null);
  }
  anim(float x,float y,int type,int type_modifier,Object obj){
    params(x,y,type,type_modifier,obj);
  }
  void params(float x,float y,int type,int type_modifier,Object obj){
    this.x=x;
    this.y=y;
    this.type=type;
    this.type_modifier=type_modifier;
    this.obj=obj;
    parameters_according_to_type();
  }
  void parameters_according_to_type(){
    frame=0;loops=0;
    switch(type){
      case FLARE_EFFECT:
        ttl=20;
        break;
    }
  }
  void tick(){
    imageMode(CENTER);
    switch(type){
      case FLARE_EFFECT:
        jewel j=(jewel)obj;
        int s=5;
        frame++;
        //blend(flare,0,0,flare.width,flare.height,(int)(x),(int)(y),frame*30,frame*30,ADD);
        switch(j.type){
          case 0:tint(255,255,0,255);break;
          case 1:tint(255,255);break;
          case 2:tint(100,150,255,255);break;
          case 3:tint(255,50,50,255);break;
          case 4:tint(255,0,255,255);break;
          case 5:tint(200,120,50,255);break;
          case 6:tint(0,255,0,255);break;
        }
        tint(255,255);
        if (j.switch_phase==5) {
          tint(255,255);
          s=10;
        }
        image(flare,(int)(x),(int)(y),(ttl-frame+s)*10,(ttl-frame+s)*10);
        if (frame>ttl) kill_me=true;
        break;
    }
    imageMode(CORNER);
  }
}
class anim_queye{
  anim a;
  Vector queye=new Vector();
  void add(float x,float y,int type){
    queye.add(new anim(x,y,type));
  }
  void add(float x,float y,int type,int type_modifier){
    queye.add(new anim(x,y,type,type_modifier));
  }
  void add(float x,float y,int type,int type_modifier,Object obj){
    queye.add(new anim(x,y,type,type_modifier,obj));
  }
  void tick(){
    for (int i=0;i<queye.size();i++){
      a=(anim)queye.get(i);
      a.tick();
      if (a.kill_me)queye.remove(i);
    }
  }
}
