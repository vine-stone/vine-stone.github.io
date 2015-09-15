/* Hitmontop in the Wilderness can spin and bounce 
 * with ease, and can also be susceptible to fainting 
 * if it gets too weak. These gestures are easy to 
 * find by manipulating the mouse buttons and wheel. 
 * However, in the Built Environment of battling (a 
 * human-created activity), Hitmontop learns how to 
 * move across its environment to attack its foes 
 * more readily. This gesture is unlikely to find by 
 * just doing things with the mouse at first, and 
 * represents the time it takes to battle with pokemon. 
 */

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.opengl.*;
import saito.objloader.*;

OBJModel hitmontop;
int x = 0;
int y = 0;
int z = 0;
float rapidspin = 0;
float agility = 0;
boolean fainted = false;
AniSequence highjumpkick;
AniSequence rollingkick;


void setup() {
  size(1000, 900, OPENGL); 
  noStroke();
  Ani.init(this);

  highjumpkick = new AniSequence(this);
  //the user jumps in the air to attack
  highjumpkick.beginSequence();
  highjumpkick.add(Ani.to(this, .5, "y", 500, Ani.CIRC_OUT));
  highjumpkick.add(Ani.to(this, 2, "y", 0, Ani.BOUNCE_OUT));
  highjumpkick.endSequence();

  rollingkick = new AniSequence(this);
  //moves around the environment to attack
  rollingkick.beginSequence();
  rollingkick.beginStep();
  rollingkick.add(Ani.to(this, 2.5, "x", 400, Ani.ELASTIC_OUT));
  rollingkick.add(Ani.to(this, 1.5, "z", 500, Ani.BACK_OUT));
  rollingkick.endStep();
  rollingkick.beginStep();
  rollingkick.add(Ani.to(this, 2.5, "x", -500, Ani.ELASTIC_OUT));
  rollingkick.add(Ani.to(this, 1.5, "z", 800, Ani.BACK_OUT));
  rollingkick.endStep();
  rollingkick.beginStep();
  rollingkick.add(Ani.to(this, 2.5, "x", 0, Ani.ELASTIC_OUT));
  rollingkick.add(Ani.to(this, 1.5, "z", 0, Ani.BACK_OUT));
  rollingkick.endStep();
  rollingkick.endSequence();

  hitmontop = new OBJModel(this, "hitmontop4tri.obj");
}


void draw () {
  background(200);
  lights();

  translate(width/2-x, height/1.5-y, 0-z);
  scale(80);

  //rotate hitmontop to be on its head
  //but if fainted, rotate on its side
  if (fainted == false) {
    rotate(radians(180));
  } else {
    rotateX(radians(270));
    rotateZ(radians(90));
    translate(x-x, y-y+3, z-z+2);
  }

  rapidspin += agility;
  rotateY(rapidspin);

  hitmontop.draw();
}


void mouseClicked() {
  if (mouseButton == LEFT && fainted == false) {
    //if left mouse is clicked, hitmontop jumps
    highjumpkick.start();
  } else if (mouseButton == CENTER && fainted == false) {
    //if center mouse is clicked, hitmontop battles
    rollingkick.start();
  } else if (mouseButton == RIGHT) {
    //if right mouse is clicked, hitmontop faints
    agility = 0;
    fainted = !fainted;
  }
}


void mouseWheel(MouseEvent event) {
  //spins hitmontop in different directions
  //also speeds and slows it down
  if (fainted == false) {
    float e = event.getCount();
    agility = agility + e/300;
  }
}

