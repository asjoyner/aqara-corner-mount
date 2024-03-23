$fa = 1;
$fs = 0.4;
height=54; // working in mm
width=38.18377;  // TODO: express in trig
mountDepth=2;
mountRadius=24.5;
pocketFrontWallThickness=.75;
pocketDepth=30;  // when viewed from the top, how far down does the pocket extend
pocketWidth=16;  // when viewed from the top, how wide is the pocket
pocketHeight=10; // when viewed from the top, how "tall" is the pocket

cablepocketFrontWallThickness=.75;
cablepocketDepth=30;  // when viewed from the top, how far down does the pocket extend
cablepocketWidth=10;  // when viewed from the top, how wide is the pocket
cablepocketHeight=7.5; // when viewed from the top, how "tall" is the pocket

powerplugDiameter=7.5;      // diameter of the 12v power plug
powerplugWallThickness=1;   // thickness of the material around the plug

intersection() {
    difference(){
        cube([width, width, height], center=true);

        // this cube flattens the front
        
        overlap=0.001;  // overlap each side by 1mm
        color("red")    
        translate([(height/2),0, 0]) // move its center to align with the front edge
        rotate(-45)                  // turn it so 
        translate([-21,0,0])   // slide it to cover the whole face
        cube([(2*width)+(overlap*2), width+(overlap*2), height+(overlap*2)], center=true);

        // cylinder the base mounts into
        rotate([90,0,-45])
        cylinder(h=mountDepth*2, r=mountRadius, center=true);

        // screw holes
        rotate([90,0,0])
        translate([width/4,0,0])
        screwhole(diameter=2, length=35);
        rotate([90,0,90])
        translate([width/4,0,-width])
        screwhole(diameter=2, length=35);
        
        // Power supply pocket
        rotate([90,0,0])    // stand upright
        rotate([0,-45,0])   // align to face
        translate([0,(height/2)-pocketDepth/2+0.001,0]) // move to top
        translate([0,0,pocketHeight/2]) // align front of pocket with face
        translate([0,0,mountDepth])     // move back by mount depth
        translate([0,0,cablepocketFrontWallThickness]) // leave some material
        cube([pocketWidth,pocketDepth,pocketHeight],center=true);
        
        // pocket for power supply cable
        color("orange")
        rotate([90,0,0])    // stand upright
        rotate([0,-45,0])   // align to face
        translate([0,height/2-cablepocketDepth/2,0]) // move to top
        translate([0,-powerplugWallThickness,0]) // move below power plug hole
        translate([0,0,cablepocketHeight/2]) // align front of pocket with face
        translate([0,0,mountDepth])   // move back by mount depth
        translate([0,0,pocketHeight])  // move back by cable pocket depth
        cube([cablepocketWidth,cablepocketDepth,cablepocketHeight],center=true);

        // hole for 12v power plug

        color("blue")
        translate([0,0,height/2-powerplugWallThickness+0.001]) // move to top
        rotate(45)  // make future moves in-line with the face
        translate([-powerplugDiameter/2,0,0])   // align front edge with the face
        translate([-mountDepth,0,0])   // move back by mount depth
        translate([-pocketHeight,0,0])  // move back by cable pocket depth
        translate([-powerplugWallThickness,0,0])  // move back from power pocket
        cylinder(h=powerplugWallThickness*2, r=powerplugDiameter/2,center=true);
        
    }
    translate([0,-2,0])
    sphere(34);
}


/*
 
    // Cable pocket
    cpH=10;
    cpW=30;
    rotate([90,0,-45])
    translate([-cpH/2,24.5,-14.001])
    cube([cpH,cpW,7]);
    */

module screwhole(diameter, length)
{
    cylinder(length,diameter,diameter);
    // TODO size and countersink holes
}