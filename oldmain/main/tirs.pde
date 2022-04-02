class Tir{
  PVector mybody;
  PVector target;
  PVector vitesse;
  int myteam;
  boolean deleteme = false;
  float spawntime;
  float mydegat;
  float expiration;
  
  //fonction
  Tir(float X,float Y,float Xaller,float Yaller,int team,float degat,float expiration){
    this.mybody = new PVector(X,Y);
    this.myteam = team;// equipe 1 ou 2
    this.vitesse = new PVector(5,5);
    this.target = new PVector(Xaller,Yaller);
    this.spawntime = gametime;
    this.mydegat = degat;
    this.expiration = expiration;
  }
  
  void action(){
    mouvement();
    afficher();
    detection();//regarde si on intersepte un ennemie
    tempdevie();
  }
  
  void tempdevie(){
    
    if(gametime-spawntime >= expiration){
      deleteme = true;
    }
  }
  
  void mouvement(){
    vitesse.set((target.x - mybody.x),(target.y - mybody.y));
    vitesse.normalize();
    mybody.add(vitesse.x*2,vitesse.y*2);
  }
  
  void afficher(){
    stroke(255,0,255);
    fill(255,0,255);
    point(mybody.x+locationX,mybody.y+locationY);
  }
  
  void detection(){
    if (target.x == mybody.x && target.y == mybody.y){
      deleteme = true; 
    }
    for (int i = units.size()-1;i >= 0;i--){
      float jesuisunesupervariable = units.get(i).myteam;
      if (jesuisunesupervariable != myteam){
        //hibox time///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(abs(mybody.x-units.get(i).mybody.x)<gamewidth/192 && abs(mybody.y-units.get(i).mybody.y)<gamewidth/192){
          units.get(i).degat(mydegat);
          deleteme = true;
        }
      }
    }
  }
}
