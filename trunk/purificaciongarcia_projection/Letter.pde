/**
 *
 * @sketch PG_projection
 * @version 2010-04-28
 * @author  Andreas Göransson, a.goransson@1scale1.com
 * 
 * Exhibition for Purification Garcia "Thinking of Dallipur" exhibition, 2010
 * 
 * Copyright (C) 2010 1scale1 HB
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */

class Letter{

  // Position of the letter, within the scene
  PVector position;
  PVector soundPos;

  /* Start - sound related variables */
  private AudioSource source;
  float pitch; // We will randomize the pitch for the sound, so there's some difference between
  /* End - sound related variables */

  ArrayList leds = new ArrayList(); // List containing all of the LED instances

  Letter( char _letter, PVector _position ){
    /* Position of letter instance */
    position = _position;

    /* Initiate the character for this letter */
    initLetter( _letter );

    /* Start - Initiate sound details */
    pitch = random(0.5,0.8);
    source = soundManager.getNextVoice();
    source.setReferenceDistance( SOUND_REFERENCE_DISTANCE );
    source.setBuffer( SOUND_BUFFER );
    source.setPitch( pitch );
    source.setLooping( true );

    // TODO: center in letter!
    soundPos = new PVector( position.x, position.y );
    source.setPosition( soundPos.x, soundPos.y, 0 ); // Carthesian system, origin in the middle
    source.play();
    /* End - Initiate sound details */
  }

  void display(GLGraphicsOffScreen _glg1, ArrayList letters){
    //updateGain();

    glg1.pushMatrix();
    // Update each Led instance and draw to offscreen buffer
    for( int i = 0; i < leds.size(); i++ ){
      ((Led)leds.get(i)).run(letters);
      ((Led)leds.get(i)).paint(_glg1);
    }
    glg1.popMatrix();
  }

  void display(GLGraphicsOffScreen _glg1){ 
    glg1.pushMatrix();
    // Update each Led instance and draw to offscreen buffer
    for( int i = 0; i < leds.size(); i++ ){
      ((Led)leds.get(i)).run();
      ((Led)leds.get(i)).paint(_glg1);
    }
    glg1.popMatrix();

    // Move the sound source to the 1'st LED
    source.setPosition( ((Led)leds.get(0)).getX(), ((Led)leds.get(0)).getY(), 0 ); // Carthesian system, origin in the middle
  }

  public ArrayList getList(){
    return leds;
  }


  /* This method defines what all letters look like. The position of each LED will be relative */
  private void initLetter( char _letter ){
    if( _letter == 'a' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, dx, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'd' ){
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, dx, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'f' ){
      leds.add( new Led( position, 0.5*dx, 0 ) );
      leds.add( new Led( position, 1.5*dx, 0 ) );
      leds.add( new Led( position, 2.5*dx, 0 ) );
      leds.add( new Led( position, 0.5*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, dx, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0.5*dx, 3*dy ) );
    }
    else if( _letter == 'g' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, dx, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'h' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, dx, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'i' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
    }
    else if( _letter == 'k' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 1.5*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'l' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'n' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, dx, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'o' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
    else if( _letter == 'p' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, dx, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
    }
    else if( _letter == 'r' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, dx, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
    }
    else if( _letter == 't' ){
      leds.add( new Led( position, dx/2, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, dx, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, dx/2, 2*dy ) );
      leds.add( new Led( position, dx/2, 3*dy ) );
      leds.add( new Led( position, dx/2 + dx, 3*dy ) );
      leds.add( new Led( position, dx/2 + 2 * dx, 3*dy ) );
    }
    else if( _letter == 'u' ){
      leds.add( new Led( position, 0, 0 ) );
      leds.add( new Led( position, 2*dx, 0 ) );
      leds.add( new Led( position, 0, dy ) );
      leds.add( new Led( position, 2*dx, dy ) );
      leds.add( new Led( position, 0, 2*dy ) );
      leds.add( new Led( position, 2*dx, 2*dy ) );
      leds.add( new Led( position, 0, 3*dy ) );
      leds.add( new Led( position, dx, 3*dy ) );
      leds.add( new Led( position, 2*dx, 3*dy ) );
    }
  }
}




















