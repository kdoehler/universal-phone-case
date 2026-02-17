include <PhoneCase2.scad>

//152 x 72.9 x 9 mm
//width of phone 
phoneWidth=73.3;
//thickness of the phone 
phoneDepth=8.6;
//height of the phone 
phoneHeight=152.4;
//vertical & horizontal radius of the corners of the case when facing toward you
phoneHwRadius=4; 
//horizontal radius of the corners of the case when facing sideways
phoneDepthRadius=1.25;
//wrap around front
lip=1.5;

//OPTIONAL card pocket; set pocketDepth to 0 to exclude
//height of the card pocket
pocketHeight=92;
//depth of the card pocket if zero, no pocket
pocketDepth=0;
//width of the card pocket
pocketWidth=60;
//vertical & horizontal radius of the corners of the pocket
pocketHwRadius=4;
//depth radius of the pocket
pocketDepthRadius=1;
//distance from bottom of phone to bottom of pocket
pocketZ=7;
//location of pocket opening
pocketOpening=RIGHT;

//OPTIONAL pocket to glue a MagSage™ compatible o-ring
// Switch to disable the o-ring pocket
magRingEnabled = true;
// Wall thickness under the o-ring
magRingWall = 0.6;
// O-ring outer diameter
magRingDiameter = 56.0;
// O-ring inner diameter
magRingHoleDiameter = 44.6;



sw=68; //width of the rectangular cutout
//collection of features (cutouts, buttons, text) to be added to the case
features = [
  [HOLE,TOP,2,16.2,.6], //side,d,x,y (mic hole)
  [SQUARE,17.8,sw,.2,phoneWidth/2-sw/2,121.5], //h,w,r,x,y (rectangular cutout)
  [OVAL,BOTTOM,12,7,phoneWidth/2], //side,l,w,x (USB jack)
  [OVAL,BOTTOM,11,3,17], //side,l,w,x (left speaker)
  [OVAL,BOTTOM,11,3,phoneWidth-17], //side,l,w,x (right speaker)
  [BUTTON,RIGHT,24,.6,0,79.75,true], //side,l,h,x,y,split (volume buttons)
  [BUTTON,RIGHT,13,.6,0,104.75,false] //side,l,h,x,y,split (power buttons)
];

module MagSafe() {
    h = wallThickness - magRingWall + 0.001;
    translate([0, 0.6, magRingWall])
    difference() {
        cylinder(r=magRingDiameter / 2, h=h);
        cylinder(r=magRingHoleDiameter / 2, h=h);
    }
}

// Make the thing
difference() {
    rotate([0,0,180]) renderCase(printable=true);
    if (magRingEnabled) MagSafe();
}