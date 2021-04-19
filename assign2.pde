PImage bg, soil, life, cabbage, soldier;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage title, startHovered, startNormal, gameover, restartHovered, restartNormal;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;
int gameState = GAME_START;

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

final int BUTTON_TOP = 360;
final int BUTTON_BOTTOM = 360 + 60;
final int BUTTON_LEFT = 248;
final int BUTTON_RIGHT = 248 + 144;

final int SINGLE_SPACE = 80;

final int LIFE_WIDTH = 50;
final int LIFE_SPACE = 50 + 20;

final int CABBAGE_SIZE = 80;
final int CABBAGE_START_Y = 160;

final int GROUNDHOG_SIZE = 80;
final int GROUNDHOG_SPEED = 80;

final int SOLDIER_SIZE = 80;
final int SOLDIER_START_Y = 160;

float groundhogX, groundhogY;
float cabbageX, cabbageY;
float soldierX, soldierY;
float soldierXSpeed = 2;
float lifeX, lifeY;
float lifeNumber = 2;

void setup() {
  size(640, 480);
  frameRate(60);

  bg = loadImage("img/bg.jpg");
  soil = loadImage("img/soil.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
  title = loadImage("img/title.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");  
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  gameover = loadImage("img/gameover.jpg");
  
  //soldier random floor appearance
  soldierX = SINGLE_SPACE * (floor(random(8))); 
  soldierY = SOLDIER_START_Y + SINGLE_SPACE * (floor(random(4)));
  
  //cabbage random appearance
  cabbageX = SINGLE_SPACE * (floor(random(8))); //80*(0~7)
  cabbageY = CABBAGE_START_Y + SINGLE_SPACE * (floor(random(4)));//80*(0~3)
  
  //groundhog
  groundhogX = SINGLE_SPACE * 4;
  groundhogY = SINGLE_SPACE * 1;
  
}

void draw() {
  
  // Switch Game State
  switch(gameState){  
    
    //GAME START
    case GAME_START:
      image(title, 0, 0);
      
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT 
         && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){
           image(startHovered, 248, 360);
           
           if(mousePressed){
             gameState = GAME_RUN;
           }
         }else{
           image(startNormal, 248, 360);
         }
      break;
    
    //GAME RUN
    case GAME_RUN:
      
      //background elements
      image(bg, 0, 0);
      image(soil, 0, SINGLE_SPACE * 2);
      //grass
      noStroke();
      fill(124, 204, 25);
      rect(0, SINGLE_SPACE * 2 - 15, width, 15);
      //sun
      strokeWeight(5);
      stroke(255, 255, 0);
      fill(253, 184, 19);
      ellipse(590, 50, 120,120);
      
      
      // life
      for(int i = 0; i < lifeNumber ; i++){
        lifeX = 10 + LIFE_SPACE * i;
        lifeY = 10;
        image(life, lifeX, lifeY);
        }   
        
      // draw soldier & soldier movement
      image(soldier, soldierX, soldierY);
      soldierX += soldierXSpeed;
      if(soldierX >= width){
        soldierX = -SOLDIER_SIZE;
      }
      //soldierX %= (width + SOLDIER_SIZE);
 
      //hit detection for soldier
      if(groundhogX < soldierX + SOLDIER_SIZE
         && groundhogX + GROUNDHOG_SIZE > soldierX
         && groundhogY < soldierY + SOLDIER_SIZE
         && groundhogY + GROUNDHOG_SIZE > soldierY){
           groundhogX = SINGLE_SPACE * 4;
           groundhogY = SINGLE_SPACE * 1;
           lifeNumber--;
         }
         
      //draw cabbage
      image(cabbage, cabbageX, cabbageY);
      
      //hit detection for cabbage
      if(groundhogX < cabbageX + CABBAGE_SIZE
         && groundhogX + GROUNDHOG_SIZE > cabbageX
         && groundhogY < cabbageY + CABBAGE_SIZE
         && groundhogY + GROUNDHOG_SIZE > soldierY){
           cabbageX = -CABBAGE_SIZE;
           cabbageY = -CABBAGE_SIZE;
           lifeNumber++; 
         }
                 
      //gameover detection
       if(lifeNumber <= 0){
         gameState = GAME_LOSE;
       }
       
      // draw groundhog     
      if(downPressed){
        image(groundhogDown, groundhogX, groundhogY);
      }else if(rightPressed){
        image(groundhogRight, groundhogX, groundhogY);
      }else if(leftPressed){
        image(groundhogLeft, groundhogX, groundhogY);
      }else{image(groundhogIdle, groundhogX, groundhogY);
      }
      
      //groundhog boundary detection
      if(groundhogY > height - SINGLE_SPACE){
          groundhogY = height - SINGLE_SPACE; 
        }    
      if(groundhogX > width - SINGLE_SPACE){
          groundhogX = width - SINGLE_SPACE; 
        }
      if(groundhogX < 0){
          groundhogX = 0; 
        }    
      break;
      
    //GAME LOSE 
    case GAME_LOSE:
      image(gameover, 0, 0);     
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
         && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM){
           image(restartHovered, 248, 360);
           
           if(mousePressed){
             gameState = GAME_RUN;
             
             lifeNumber = 2;
             
             //soldier random floor appearance
             soldierX = SINGLE_SPACE * (floor(random(8))); 
             soldierY = SOLDIER_START_Y + SINGLE_SPACE * (floor(random(4)));
              
             //cabbage random appearance
             cabbageX = SINGLE_SPACE * (floor(random(8))); //80*(0~7)
             cabbageY = CABBAGE_START_Y + SINGLE_SPACE * (floor(random(4)));//80*(0~3)
             
           }
       }else{
         image(restartNormal, 248, 360);
       } 
      break;
  }
}

void keyPressed(){
  switch(keyCode){
    case DOWN:
      groundhogY += GROUNDHOG_SPEED;
      downPressed = true;
    break;
    
    case LEFT:
      groundhogX -= GROUNDHOG_SPEED;
      leftPressed = true;
    break;
      
    case RIGHT:
      groundhogX += GROUNDHOG_SPEED;
      rightPressed = true;
    break;
  }
}

void keyReleased(){    
    switch(keyCode){
    case DOWN:
      downPressed = false;
    break;
    
    case LEFT:
      leftPressed = false;
    break;
      
    case RIGHT:
      rightPressed = false;
    break;
  }
}
