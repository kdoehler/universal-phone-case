TOP=1; //indicates top edge of phone
BOTTOM=2; //bottom edge
LEFT=3; //etc
RIGHT=4; 
BACK=5;
SQUARE=1; //h,w,r,x,y (always on back, e.g. camera cutout, coordinates are to bottom-left)
OVAL=2;  //side,l,w,x (e.g. power jack,coordinates are to center)
HOLE=3; //side,d,x,y (small hole for mic, etc, coordinates are to center)
BUTTON=4; //side,l,h,x,y,split (use split for vol, coordinates are to center)
CIRCLE=5; //d,x,y,taper (large hole for camera or fingerprint, coordinates are to center)
TEXT=6; //text,x,y,size,typeface (always on back, coordinates are to center)


//smoothness of curves (10-100 -> rough to fine)
smoothness=100;



//thickness of the shell of the case
wallThickness=1.5;
//smoothness of curves
$fn=smoothness;


// rectangular prism with rounded corners
module roundedBox(width,depth, height, widthRadius,depthRadius)
{
  tr=widthRadius-depthRadius;
  hull()
  {
    translate([widthRadius,depthRadius,widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([width-widthRadius,depthRadius,widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([width-widthRadius,depth-depthRadius,widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([widthRadius,depth-depthRadius,widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([widthRadius,depthRadius,height-widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([width-widthRadius,depthRadius,height-widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([width-widthRadius,depth-depthRadius,height-widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);

    translate([widthRadius,depth-depthRadius,height-widthRadius])
    rotate([90,0,0])
    rotate_extrude()
    translate([widthRadius-depthRadius,0,0])
    circle(depthRadius);
      
  }
}


//rounded rectangular rim
module rim(width,depth,height,radius)
{
  //left
  translate([0,0,radius])
  cylinder(h=height-radius*2,d=depth);
  //right
  translate([width,0,radius])
  cylinder(h=height-radius*2,d=depth);
  //bottom
  translate([radius,0,0])
  rotate([0,90,0])
  cylinder(h=width-radius*2,d=depth);
  //top
  translate([radius,0,height])
  rotate([0,90,0])
  cylinder(h=width-radius*2,d=depth);
  //bottom-left
  translate([radius,0,radius])
  rotate([90,180,0])
  rotate_extrude(angle=90)
  translate([radius,0,0])
  circle(d=depth);
  //top-left
  translate([radius,0,height-radius])
  rotate([-90,180,0])
  rotate_extrude(angle=90)
  translate([radius,0,0])
  circle(d=depth);
  //top-right
  translate([width-radius,0,height-radius])
  rotate([90,0,0])
  rotate_extrude(angle=90)
  translate([radius,0,0])
  circle(d=depth);
  //bottom-right
  translate([width-radius,0,radius])
  rotate([90,90,0])
  rotate_extrude(angle=90)
  translate([radius,0,0])
  circle(d=depth);
}

//a placeholder for the phone to help visualize the fit
module renderPhone()
{
  color("#606060")
  roundedBox(phoneWidth, phoneDepth, phoneHeight,phoneHwRadius,phoneDepthRadius);
}

//external limits of case without features
module blankCase()
{
  translate([-wallThickness,-wallThickness,-wallThickness])
  roundedBox(phoneWidth+wallThickness*2, (phoneDepth+pocketDepth)+wallThickness*2, phoneHeight+wallThickness*2,phoneHwRadius+wallThickness,phoneDepthRadius+wallThickness);
}

//the main body of the case
module renderCase(printable)
{
  translate([printable?phoneWidth/2:0,printable?-phoneHeight/2:0,printable?wallThickness:0])
  rotate([printable?-90:0,printable?180:0,0])
  //add protusions
  union()
  {
    //add holes and indents
    difference()
    {
      //body shape, minus any major cutouts
      difference()
      {
        
        //main body
        translate([-wallThickness,-wallThickness,-wallThickness])
          roundedBox(phoneWidth+wallThickness*2, phoneDepth+pocketDepth+wallThickness*2, phoneHeight+wallThickness*2,phoneHwRadius+wallThickness,phoneDepthRadius+wallThickness);

        //front cutout
        translate([lip,(phoneDepth+pocketDepth)/2,lip])
        roundedBox(phoneWidth-lip*2, (phoneDepth+pocketDepth)+wallThickness, phoneHeight-lip*2,phoneHwRadius-lip,1);   
      }

      //pocket cutout
      translate([0,pocketDepth,0])
      roundedBox(phoneWidth, phoneDepth, phoneHeight,phoneHwRadius,phoneDepthRadius);
      if(pocketDepth>0)
      {
        //pocket cutout
        translate([(phoneWidth-pocketWidth)/2+wallThickness,0,pocketZ+wallThickness])
        roundedBox(pocketWidth-wallThickness*2, pocketDepth+pocketDepthRadius*sqrt(.5), pocketHeight-wallThickness*2,pocketHwRadius,pocketDepthRadius);
        //door-side hole
        translate([pocketOpening==RIGHT?(phoneWidth-pocketWidth)/2:pocketOpening==LEFT?(phoneWidth+pocketWidth)/2:phoneWidth/2,-wallThickness/2,pocketOpening==RIGHT || pocketOpening==LEFT?pocketZ+pocketHeight/2:pocketZ+pocketHeight])
        rotate([0,pocketOpening==RIGHT?0:pocketOpening==LEFT?180:90,0])
        difference()
        {
          rotate([90,0,0])
          cylinder(d=15,h=wallThickness*2+pocketDepth*2,center=true);
          translate([-15,0,0])
          cube([30,30,30],center=true);
        }
        //door hinge
        translate([phoneWidth/2,pocketDepth/2+wallThickness/2,pocketHeight/2+pocketZ])
        cube([pocketOpening==TOP?pocketWidth:wallThickness,pocketDepth+wallThickness,pocketOpening==TOP?wallThickness:pocketHeight],center=true);
        //door-side latch gaps
        translate([pocketOpening==TOP?phoneWidth/2:pocketOpening==RIGHT?(phoneWidth-pocketWidth)/2:(phoneWidth+pocketWidth)/2,wallThickness+pocketDepth,pocketOpening==TOP?pocketZ+pocketHeight:pocketZ+pocketHeight/2])
        rotate([0,pocketOpening==TOP?0:pocketOpening==RIGHT?-90:90,0])
        difference()
        {
          rotate([45,0,0])
          cube([pocketOpening==TOP?pocketWidth*.75:pocketHeight*.75,pocketDepth,pocketDepth],center=true);
          translate([0,0,-150])
          cube([300,300,300],center=true);
        }    

        //door cut
        doorGap=wallThickness/2;
        r1=pocketHwRadius-doorGap/2;
        h1=pocketDepth+wallThickness*3;
        w1=pocketOpening==TOP?pocketHeight/2-pocketHwRadius:pocketWidth/2-pocketHwRadius;
        x0=(phoneWidth-pocketWidth)/2;
        if(pocketOpening==RIGHT)
        {
          //upper curve
          translate([x0+pocketHwRadius,0,pocketHeight+pocketZ-pocketHwRadius])
          rotate([90,-90,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //lower curve
          translate([x0+pocketHwRadius,0,pocketZ+pocketHwRadius])
          rotate([90,180,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //bottom
          translate([x0+w1/2+pocketHwRadius,0,pocketZ+doorGap/2])
          cube([w1,h1,doorGap],center=true);
          //top
          translate([x0+w1/2+pocketHwRadius,0,pocketZ+pocketHeight-doorGap/2])
          cube([w1,h1,doorGap],center=true);
          //side
          translate([x0+doorGap/2,0,pocketZ+pocketHeight/2])
          cube([doorGap,h1,pocketHeight-pocketHwRadius*2],center=true);
        }
        else if(pocketOpening==LEFT)
        {
          //upper curve
          translate([x0+pocketWidth-pocketHwRadius,0,pocketHeight+pocketZ-pocketHwRadius])
          rotate([90,0,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //lower curve
          translate([x0+pocketWidth-pocketHwRadius,0,pocketZ+pocketHwRadius])
          rotate([90,90,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //bottom
          translate([x0+pocketWidth-w1/2-pocketHwRadius,0,pocketZ+doorGap/2])
          cube([w1,h1,doorGap],center=true);
          //top
          translate([x0+pocketWidth-w1/2-pocketHwRadius,0,pocketZ+pocketHeight-doorGap/2])
          cube([w1,h1,doorGap],center=true);
          //side
          translate([x0+pocketWidth-doorGap/2,0,pocketZ+pocketHeight/2])
          cube([doorGap,h1,pocketHeight-pocketHwRadius*2],center=true);
        }
        else if(pocketOpening==TOP)
        {
          //left curve
          translate([x0-pocketHwRadius+pocketWidth,0,pocketHeight+pocketZ-pocketHwRadius])
          rotate([90,0,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //right curve
          translate([x0+pocketHwRadius,0,pocketHeight+pocketZ-pocketHwRadius])
          rotate([90,-90,0])
          rotate_extrude(angle=90)
          translate([r1,0,0])
          square([doorGap,h1],center=true);
          //left
          translate([(phoneWidth+pocketWidth-doorGap)/2,0,pocketZ+pocketHeight-w1/2-pocketHwRadius])
          cube([doorGap,h1,w1],center=true);
          //right
          translate([(phoneWidth-pocketWidth+doorGap)/2,0,pocketZ+pocketHeight-w1/2-pocketHwRadius])
          cube([doorGap,h1,w1],center=true);
          //top
          translate([phoneWidth/2,0,pocketZ+pocketHeight-doorGap/2])
          cube([pocketWidth-pocketHwRadius*2,h1,doorGap],center=true);
        }
      }
      //cutouts (holes, engravings)
      for(feature=features)
      {
        cutFeature(feature);
      }
    }
    if(pocketDepth>0)
    {
      //door latch
      translate([pocketOpening==LEFT?(phoneWidth+pocketWidth)/2-wallThickness/2:pocketOpening==RIGHT?(phoneWidth-pocketWidth)/2+wallThickness/2:phoneWidth/2,pocketDepth,pocketOpening==TOP?pocketHeight+pocketZ-wallThickness/2:pocketZ+pocketHeight/2])
      rotate([0,pocketOpening==TOP?-90:pocketOpening==RIGHT?180:0,0])
      difference()
      {
        translate([-wallThickness/4,0,0])
        rotate([0,0,45])
        cube([wallThickness*2,wallThickness*2,pocketOpening==TOP?pocketWidth*.7:pocketHeight*.7],center=true);
        translate([-150-wallThickness/2,0,0])
        cube(300,center=true);
        translate([0,150,0])
        cube(300,center=true);
        cube([wallThickness*3,wallThickness*3,15],center=true);
      }
    }   
    
    //protrusions (e.g. buttons)
    for(feature=features)
    {
      addFeature(feature);
    }
    
    //tabs (e.g. button membranes)
    intersection()
    {
      blankCase();
      union()
      {
        for(feature=features)
        {
          addFeatureTabs(feature);
        }
      }
    }

  }

}

//subtract a feature from the case
module cutFeature(feature)
{
  type = feature[0];
  if(type==HOLE)
  {
    cutHole(feature);
  }
  else if(type==SQUARE)
  {
    cutSquare(feature);
  }
  else if(type==OVAL)
  {
    cutOval(feature);
  }
  else if(type==BUTTON)
  {
    cutButton(feature);
  }
  else if(type==CIRCLE)
  {
    cutCircle(feature);
  }
  else if(type==TEXT)
  {
    cutText(feature);
  }
}

//union a feature with the case
module addFeature(feature)
{
  type = feature[0];
  if(type==BUTTON)
  {
    addButton(feature);
  }
}

//union a feature's tab with the case
module addFeatureTabs(feature)
{
  type = feature[0];
  if(type==BUTTON)
  {
    addButtonTabs(feature);
  }
}

//small holes
module cutHole(feature)
{
  //side,d,x,y
  side=feature[1];
  d=feature[2];
  x=feature[3];
  y=feature[4];
  translate([(side==LEFT)?phoneWidth:(side==RIGHT)?0:phoneWidth-x,phoneDepth/2+pocketDepth+((side==TOP||side==BOTTOM)?y:0),((side==TOP)?phoneHeight:(side==BOTTOM)?0:y)])
  rotate([0,(side==LEFT||side==RIGHT)?90:0,0])
  cylinder(d=d,h=wallThickness*4,center=true);
}

//ovals
module cutOval(feature)
{
  //side,l,w,x
  side=feature[1];
  l=feature[2];
  w=feature[3];
  x=feature[4];
  translate([phoneWidth-x+l/2,phoneDepth/2+pocketDepth,(side==TOP)?phoneHeight:0])
  hull()
  {
    translate([w/2-l,0,0])
    cylinder(d=w,h=wallThickness*4,center=true);
    translate([-w/2,0,0])
    cylinder(d=w,h=wallThickness*4,center=true);
  }
}

//text (back only)
module cutText(feature)
{
  //text,x,y,size,typeface
  t=feature[1];
  x=feature[2];
  y=feature[3];
  size=feature[4];
  typeface=feature[5];
  translate([x,-wallThickness/2,y])
  rotate([90,0,0])
  linear_extrude(wallThickness)
  text(size=size,text=t,halign="center",valign="center",font=typeface);
}

//hole for button
module cutButton(feature)
{
  //side,l,h,x,y,split
  side=feature[1];
  l=feature[2];
  h=feature[3];
  x=feature[4];
  y=feature[5];
  w=phoneDepth*.66;
  split=feature[6];
  translate([(side==LEFT)?phoneWidth:(side==RIGHT)?0:phoneWidth-x,phoneDepth/2+pocketDepth,(side==TOP)?phoneHeight:(side==BOTTOM)?0:y])
  rotate([0,(side==LEFT||side==RIGHT)?90:0,0])
  hull()
  {
    translate([w/2-l/2,0,0])
    cylinder(d=w,h=wallThickness*4,center=true);
    translate([l/2-w/2,0,0])
    cylinder(d=w,h=wallThickness*4,center=true);
  }
}

//button pad
module addButton(feature)
{
  //side,l,h,x,y,split
  side=feature[1];
  l=feature[2]-2;
  h=feature[3];
  x=feature[4];
  y=feature[5];
  w=phoneDepth*.75-2;
  split=feature[6];
  translate([(side==LEFT)?phoneWidth:(side==RIGHT)?0:phoneWidth-x,phoneDepth/2+pocketDepth,(side==TOP)?phoneHeight:(side==BOTTOM)?0:y])
  rotate([0,side==RIGHT?90:side==LEFT?-90:side==TOP?180:0,0])
  union()
  {
    difference()
    {
      hull()
      {
        translate([w/2-l/2,0,-wallThickness/2-h])
        cylinder(d=w,h=wallThickness,center=true);
        translate([l/2-w/2,0,-wallThickness/2-h])
        cylinder(d=w,h=wallThickness,center=true);
      }
      if(split) //divider e.g. for vol buttons 
      {
        translate([0,0,-h-wallThickness])
        cube([1,w+3,1],center=true);
      }
      
    }
    
  }
}

//membranes holding button pads in place
module addButtonTabs(feature)
{
  //side,l,h,x,y,split
  side=feature[1];
  l=feature[2]-2;
  h=feature[3];
  x=feature[4];
  y=feature[5];
  w=phoneDepth*.75-2;
  split=feature[6];
  translate([(side==LEFT)?phoneWidth:(side==RIGHT)?0:phoneWidth-x,phoneDepth/2+pocketDepth,(side==TOP)?phoneHeight:(side==BOTTOM)?0:y])
  rotate([0,side==RIGHT?90:side==LEFT?-90:side==TOP?180:0,0])
  difference()
  {
    union()
    {
     
      translate([-l/2,0,-0.5-h])
      cube([w,w+3,2],center=true);
      translate([l/2,0,-0.5-h])
      cube([w,w+3,2],center=true);
      if(split)
      {
        translate([0,0,-0.5-h])
        cube([2,w+3,2],center=true);
      }
    }
    translate([0,0,0])
    hull()
    {
      translate([w/2-l/2,0,0])
      cylinder(d=w,h=h*2,center=true);
      translate([l/2-w/2,0,0])
      cylinder(d=w,h=h*2,center=true);
    }

  }
}

//rounded square hole
module cutSquare(feature)
{
  //h,w,r,x,y
  h=feature[1];
  w=feature[2];
  r=feature[3];
  x=feature[4];
  y=feature[5];
  x1=phoneWidth-(x+w-r);
  x2=phoneWidth-(x+r);
  y1=y+h-r;
  y2=y+r;
  hull()
  {
    translate([x1,0,y1])
    rotate([90,0,0])
    cylinder(r=r,h=(wallThickness+pocketDepth)*4,center=true);
    translate([x1,0,y2])
    rotate([90,0,0])
    cylinder(r=r,h=(wallThickness+pocketDepth)*4,center=true);
    translate([x2,0,y2])
    rotate([90,0,0])
    cylinder(r=r,h=(wallThickness+pocketDepth)*4,center=true);
    translate([x2,0,y1])
    rotate([90,0,0])
    cylinder(r=r,h=(wallThickness+pocketDepth)*4,center=true);
  }
}

//circular cutout on back (e.g. fingerprint reader)
module cutCircle(feature)
{
  //d,x,y,taper
  d=feature[1];
  x=feature[2];
  y=feature[3];
  taper=feature[4];

  translate([x,0,y])
  rotate([90,0,0])
  cylinder(d=d,h=(wallThickness+pocketDepth)*4,center=true);
  if(taper)
  {
    translate([x,-wallThickness,y])
    rotate([90,0,0])
    cylinder(d1=d,d2=d+(wallThickness+pocketDepth)*4,h=(wallThickness+pocketDepth)*2,center=true);
  }
}
