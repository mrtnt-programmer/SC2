class Terrain{
  IntList unitaspawn;
  
  Terrain(int xdonne,int ydonne){
  gamewidth = xdonne;
  gameheight = ydonne;
  unitaspawn = new IntList();
 // team2buildings.add(new building((gamewidth/16)*11,gameheight/2,2,1));
 // team1buildings.add(new building((gamewidth/16)*5,gameheight/2,1,1));
  }
    
  void action(){
    actionunits();//active/enleve/les marin ansi que verifie les marin dans le constructeur
    spawnwaves();//on mete TOUT les marin de TOUT les constructeur sur le terrain(si le temp est bon)
    victory();//verifie si quelquin a gagner
    extra();
  }
  
  void actionunits(){
    for (int i = units.size()-1;i >= 0;i--){//on active/enleve les marin
      units.get(i).action();
      if(units.get(i).spawn){//si dans le constructeur spawn
        unitaspawn.append(i);
      }
      if (units.get(i).dead() || units.get(i).deleteme){
        units.remove(i);
      }
    }
  }
  
  void spawnwaves(){
    if (spawntime >= 5){//tous les 5sec on spawn l,armee
       spawnterrain();
       spawntime = 0;
    }else{
      if(unitaspawn.size() >= 1 ){
        unitaspawn.clear();
      }
    }
  }
  
  void spawnterrain(){
    for (int i = unitaspawn.size()-1;i >= 0;i--){
      /////////////////////////////////////////////////////////////////////////////////////to optimes/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(units.get(unitaspawn.get(i)).myteam == 1){
        spawnuniter(units.get(unitaspawn.get(i)).mybody.x + (gamewidth/16)*3,units.get(unitaspawn.get(i)).mybody.y,units.get(unitaspawn.get(i)).myteam,2,units.get(unitaspawn.get(i)).nomuniter);
      }
      if(units.get(unitaspawn.get(i)).myteam == 2){
        spawnuniter(units.get(unitaspawn.get(i)).mybody.x - (gamewidth/16)*3,units.get(unitaspawn.get(i)).mybody.y,units.get(unitaspawn.get(i)).myteam,2,units.get(unitaspawn.get(i)).nomuniter);
      }
    }
  }
   
  void TerrainMaker(int xdonne,int ydonne){
    int x = xdonne;
    int y = ydonne;
    push();
    fill(0,0,0);
    rect(x+gamewidth/4,y+gameheight/3,gamewidth/2,gameheight/3);//le terrain de combat
    fill(255,0,255);
    rect(x+gamewidth/16,y+gameheight/3,gamewidth/8,gameheight/3);//joueur1 terrain de l'armee
    rect(x+(gamewidth/4)*3+gamewidth/16,y+gameheight/3,gamewidth/8,gameheight/3);//joueur2 terrain de l'armee
    pop();
    
  }
  
  void spawnuniter(float xdonne,float ydonne,int team,int combatdonne,String nomuniterdonne){
    units.add(new Unit(xdonne,ydonne,team,combatdonne,nomuniterdonne));////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  
  void extra(){
    push();
    fill(0,0,0);textAlign(BASELINE,BASELINE);textSize(12);
    text(gametime,width/2,height/26);
    text(spawntime,width/2,height/20);
    pop();
  }
  void victory(){
    if (victory1 && alreadywin == false){
      background(0,0,0);
      text("blue wins",width/2,height/2);
      text("press space to continu",width/2,height/2+10);
    }
    if (victory2 && alreadywin == false){
      background(0,0,0);
      text("red wins",width/2,height/2);  
      text("press space to continu",width/2,height/2+10);    
    }
  }
  

  void baraction(){
    gamebar();//montrer la bar
    gamebardetection();//regarder si on click dessu
  }
  
  void gamebar(){
    push();
    fill(200,200,200);
    int ecart = gameheight/12;
    int gamebarheight = (gameheight/3)*2 + ecart;
    rect(0,gamebarheight,gamewidth,gameheight/3-ecart);//le bar general
    ////////////////////////////////////////////////////////RIGHT/////////////////////////////////////////////////////////////////////////
    int Rwidth = (gamewidth/4)/6;
    int Rheight = (gameheight/3)/4;
    rect((gamewidth/4)*3,gamebarheight,gamewidth/4,gameheight/3-ecart);//le bar d'uniter et d'abiliter
    
    fill(200,200,200);
    rect(((gamewidth/4)*3)+10,gamebarheight+10,Rwidth-10,(gameheight/3-ecart)/4-10);//le bar de marin
    fill(0,0,0);textAlign(CENTER,CENTER);textSize(Rwidth/4);
    text("marin",((gamewidth/4)*3)+10,gamebarheight+10,Rwidth-10,(gameheight/3-ecart)/4-10);
    
    fill(200,200,200);
    rect(((gamewidth/4)*3)+Rwidth+10,gamebarheight+10,Rwidth-10,(gameheight/3-ecart)/4-10);//le bar de firebat
    fill(0,0,0);textAlign(CENTER,CENTER);textSize(Rwidth/4);
    text("firebat",((gamewidth/4)*3)+Rwidth+10,gamebarheight+10,Rwidth-10,(gameheight/3-ecart)/4-10);
    pop();
}
  void gamebardetection(){
    
    push();
    if (mouseX > ((gamewidth/4)*3)+10 && mouseY > abs((gameheight/3)*2 + gameheight/12+10)){
      selectedunit = "marin";
    }
    if (mouseX > abs((gamewidth/4)*3+(gamewidth/4)/6+10) && mouseY > abs((gameheight/3)*2 + gameheight/12+10)){//march mais doit optimiser
      selectedunit = "firebat";
    }
    pop();
  }
}
