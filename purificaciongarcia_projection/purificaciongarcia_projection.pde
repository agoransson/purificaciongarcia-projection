/* Sound related imports */
import net.java.games.joal.*;
import net.java.games.joal.util.*; 
import toxi.audio.*;
import toxi.geom.*;

/* Graphics related imports */
import processing.opengl.*;
import codeanticode.glgraphics.*;

/* Camera related imports */
import oscP5.*;
import netP5.*;

/**
 *
 * @sketch PG_projection
 * @version 2010-05-08
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

/* Begin - Screen definition variables */
int SIZE_W;
int SIZE_H;
/* End - Screen definition variables */

/* Begin - Shader */
GLGraphicsOffScreen glg1;
GLTexture bloomMask, destTex;
GLTexture tex0, tex2, tex4, tex8, tex16, tex32;
GLTextureFilter extractBloom, blur, blend4, toneMap;
/* End - Shader variables */

/* Begin - LED instance variables */
PImage bg; // Image which will be rendered, optionally, for each LED instance
ArrayList message = new ArrayList(); // List containing all of the Letter instances
PVector mousePosition; // Mouse position
/* End - LED instance variables */

/* Begin - Global sound variables */
int NUMBER_OF_LETTERS = 17; // We need one of these for every sound source! Not guaranteed!
JOALUtil audioSys;
SoundListener user;
MultiTimbralManager soundManager;
AudioBuffer SOUND_BUFFER;
/* End - Global sound variables */

/* Start - Camera related variables */
OscP5 osc;
int blobNumber = 0;
/* End - Camera related variables */

/* Begin - global flocking variable */
boolean FLOCK = true;
/* End - global flocking variable */

void setup(){
  size( screen.width, screen.height, GLConstants.GLGRAPHICS );
  //size( 940, 600, GLConstants.GLGRAPHICS );

  // Inflate all settings from the xml prefs
  inflateSettings( "pgsettings.xml" );
  SIZE_W = width;
  SIZE_H = height;

  // Make sure the cursor is not displayed on the projection
  noCursor();

  /* Start - Sound related initializations */
  audioSys = JOALUtil.getInstance(); // OpenAL is a singleton, so we need to ask for it
  audioSys.init();
  soundManager=new MultiTimbralManager(audioSys, NUMBER_OF_LETTERS);
  SOUND_BUFFER = audioSys.loadBuffer(dataPath("sound.wav"));
  user = audioSys.getListener();
  /* End - Sound related initializations */

  // Load background image file, this is the background that will be drawn by the LED class instances
  bg = loadImage( "final.png" );

  // Assemble message (initialize all Led instances and add to list)
  newtxt();

  // Setup offscreen buffer and initialize source
  glg1 = new GLGraphicsOffScreen( this, SIZE_W, SIZE_H );
  glg1.imageMode( CENTER );

  // Source, offscreenbuffer will be copied into this source before filtering
  //srcTex = new GLTexture( this, SIZE_W, SIZE_H );

  /* Start - Loading filters */
  extractBloom = new GLTextureFilter( this, "ExtractBloom.xml" );
  blur = new GLTextureFilter( this, "Blur.xml" );
  blend4 = new GLTextureFilter( this, "Blend4.xml" );  
  toneMap = new GLTextureFilter( this, "ToneMap.xml" );
  /* End - Loading filters */

  // Initialize final texture, this one will be rendered to screen
  destTex = new GLTexture( this, SIZE_W, SIZE_H );

  /* Start - Initialize filters and masks */
  bloomMask = new GLTexture( this, SIZE_W, SIZE_H, GLTexture.FLOAT );
  tex0 = new GLTexture( this, SIZE_W, SIZE_H, GLTexture.FLOAT );
  tex2 = new GLTexture( this, SIZE_W / 2, SIZE_H / 2, GLTexture.FLOAT );
  tex4 = new GLTexture( this, SIZE_W / 4, SIZE_H / 4, GLTexture.FLOAT );
  tex8 = new GLTexture( this, SIZE_W / 8, SIZE_H / 8, GLTexture.FLOAT );
  tex16 = new GLTexture( this, SIZE_W / 16, SIZE_H / 16, GLTexture.FLOAT );
  tex32 = new GLTexture( this, SIZE_W / 32, SIZE_H / 32, GLTexture.FLOAT );
  /* End - Initialize filters and masks */

  /* Start - OSC initializations */
  osc = new OscP5( this, oscport );
  /* End - OSC initializations */

  // Initialize mouse position PVector
  mousePosition = new PVector();
}

void draw(){
  // Move the user in the soundscape (this is only for OpenAL)
  user.setPosition( mousePosition.x, mousePosition.y, 0 );

  /* Debugging properties, if we are debugging and we are NOT using the iphone set the position using mouse */
  if( debugging != 0 && iphone == 0 )
    mousePosition.set( mouseX, mouseY, 0 );

  /* Start - Render items to offscreen buffer */
  glg1.beginDraw();
  {
    // Background
    glg1.background( 0 );
    
    /* Begin - Led rendering */
    for( int i = 0; i < message.size(); i++ ){
      if( !FLOCK )
        ((Letter)message.get(i)).display(glg1, message);
      else
        ((Letter)message.get(i)).display(glg1);
    }
    /* End - Led rendering */

    /* Begin - Debugging rendering */
    /* Mouse position */
    if( debugging != 0 && iphone == 0 ){
      glg1.pushMatrix();
      glg1.translate( mousePosition.x, mousePosition.y );
      glg1.fill( 255, 0, 0 );
      glg1.ellipse( 0, 0, 20, 20 );
      glg1.popMatrix();
    }
    /* iPhone position */
    if( iphone != 0 ){
      glg1.pushMatrix();
      glg1.translate( mousePosition.x, mousePosition.y );
      glg1.fill( 255, 255, 0 );
      glg1.ellipse( 0, 0, 20, 20 );
      glg1.fill( 0 );
      glg1.ellipse( 0, 0, 10, 10 );
      glg1.popMatrix();
    }
    /* End - Debuggin rendering */
  }
  glg1.endDraw();
  /* End - Render items to offscreen buffer */

  // Extracting the bright regions from input texture.
  extractBloom.setParameterValue( "bright_threshold", brightnessFX );
  extractBloom.apply( glg1.getTexture(), tex0 );

  /* Start - Downsampling with blur */
  tex0.filter( blur, tex2 );
  tex2.filter( blur, tex4 );    
  tex4.filter( blur, tex8 );    
  tex8.filter( blur, tex16 );     
  tex16.filter( blur, tex32 );
  /* End - Downsampling with blur */

  /* Start - Blending downsampled textures */
  blend4.apply( new GLTexture[]{ 
    tex2, tex4, tex8, tex16, tex32     }
  , new GLTexture[]{ 
    bloomMask     } 
  );
  /* End - Blending downsampled textures */

  /* Start - Final bloom effect assembly */
  toneMap.setParameterValue( "exposure", exposureFX );
  toneMap.setParameterValue( "bright", brightnessFX );
  toneMap.apply( new GLTexture[]{ 
    glg1.getTexture(), bloomMask     }
  , new GLTexture[]{ 
    destTex     } 
  );
  /* End - Final bloom effect assembly */

  // Render final output!
  image( destTex, 0, 0, width, height );
}

public void stop() {
  audioSys.shutdown();
  println("stop");
  super.stop();
}

// ==============================================
// =============== SETTINGS =====================
// ==============================================

/* Begin - XML Preferences file, used for setting certain variables for the exhibition */
/* XML SETTING FILE */
XMLElement settingsfile;
/* Shader effect values */
float brightnessFX, exposureFX;
/* OSC port */
int oscport;
/* Led values */
float d, amountOfJitter;
int nbrOfSeeks;
float maxforce,maxspeed;
float desiredseparation, neighbordist; // = 50.0; // Boid
/* Letter values */
float dx, dy;
/* Message values */
int nudgeFirstLine, nudgeSecondLine, nudgeThirdLine; // nudging on x-axis
int nudgeY; // Nudge the entire message on y-axis
int letterspacing;
/* Start - Sound values */
float SOUND_REFERENCE_DISTANCE;
/* Debugging? */
int debugging;
/* Using iphone? */
int iphone;

void inflateSettings( String _file ){
  /* Initialize the XML prefs file */
  settingsfile = new XMLElement( this, _file );
  XMLElement[] prefs = settingsfile.getChildren();

  /* SHADER SETTINGS */
  brightnessFX = Float.valueOf( prefs[0].getContent().trim() );
  exposureFX = Float.valueOf( prefs[1].getContent().trim() );

  /* OSC */
  oscport = Integer.valueOf( prefs[2].getContent().trim() );

  /* LED SETTINGS */
  d = Float.valueOf( prefs[3].getContent().trim() );
  amountOfJitter = Float.valueOf( prefs[4].getContent().trim() );
  nbrOfSeeks = Integer.valueOf( prefs[5].getContent().trim() );
  maxspeed = Float.valueOf( prefs[6].getContent().trim() );
  maxforce = Float.valueOf( prefs[7].getContent().trim() );
  desiredseparation = Float.valueOf( prefs[8].getContent().trim() );
  neighbordist = Float.valueOf( prefs[9].getContent().trim() );

  /* LETTER SETTINGS */
  dx = Integer.valueOf( prefs[10].getContent().trim() );
  dy = Integer.valueOf( prefs[11].getContent().trim() );

  /* MESSAGE SETTINGS */
  nudgeFirstLine = Integer.valueOf( prefs[12].getContent().trim() );
  nudgeSecondLine = Integer.valueOf( prefs[13].getContent().trim() );
  nudgeThirdLine = Integer.valueOf( prefs[14].getContent().trim() );
  nudgeY = Integer.valueOf( prefs[15].getContent().trim() );

  letterspacing = Integer.valueOf( prefs[16].getContent().trim() );

  /* SOUND SETTINGS */
  SOUND_REFERENCE_DISTANCE = Float.valueOf( prefs[17].getContent().trim() );

  /* DEBUGGING */
  debugging = Integer.valueOf( prefs[18].getContent().trim() );
  /* IPHONE */
  iphone = Integer.valueOf( prefs[19].getContent().trim() );
}
/* End - XML Preferences file */



























