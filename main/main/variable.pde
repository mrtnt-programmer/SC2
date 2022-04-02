import ddf.minim.*;
Minim minim;
AudioPlayer music;
public boolean playmusic = false;

public ArrayList<Unit> units;
public Unit unit;
public int topID = 0;
public ArrayList<Player> players;
public Player player;
public Terrain terrain;
public int block;//un carre dans le cadrillage
public boolean showcadrillage;//si on affiche le cardillage ou pas
//int gamewidth = 7680,gameheight = 4320;
public int gamewidth,gameheight;
public int locationX,locationY;
public float gametime;//temp depuis le debut du programme

public boolean moveleft,moveright,moveup,movedown;
public boolean bigger,smaller;
public boolean victory1 = false,victory2 = false,gamefinished = false,alreadywin = false;//savoir si quelquin a gagne ,qui et si on continue;

public int findunit;
public String selectedunit = "marin";
public int selectedcolor = 1; 

public PImage marinstill,marinstill2;

public int currentplayer = 1;

public boolean rapidfire = false;

boolean find_unit_error;
