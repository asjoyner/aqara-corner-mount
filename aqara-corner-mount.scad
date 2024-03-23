$fa = 1;
$fs = 0.4;
height=54; // working in mm
width=height/sqrt(2);
mountDepth=2;
mountRadius=24.5;
pocketFrontWallThickness=.75;
pocketDepth=30;  // when viewed from the top, how far down does the pocket extend
pocketWidth=16;  // when viewed from the top, how wide is the pocket
pocketHeight=10; // when viewed from the top, how "tall" is the pocket

cablepocketFrontWallThickness=.75;
cablepocketDepth=30;  // when viewed from the top, how far down does the pocket extend
cablepocketWidth=10;  // when viewed from the top, how wide is the pocket
cablepocketHeight=10; // when viewed from the top, how "tall" is the pocket

powerplugDiameter=10.5;      // diameter of the 12v power plug
powerplugWallThickness=1;   // thickness of the material around the plug

wallCornerRelief=3;

intersection() {
    difference(){
        // Start with a cube of the right dimensions
        cube([width, width, height], center=true);

        // add a cube that flattens the front
        overlap=0.001;  // overlap each side by 1mm
        color("red")    
        rotate(45)                  // turn it so 
        translate([(height/2),0,0]) // slide it to cover the whole face
        cube([(height)+(overlap*2), height+(overlap*2), height+(overlap*2)], center=true);
        // carve out the cylinder the base mounts into
        rotate([90,0,-45])
        cylinder(h=mountDepth*2, r=mountRadius, center=true);

        // screw holes
        rotate([-90,0,0])
        translate([width/4,0,0])
        screwhole(length=width/2);
        rotate([90,0,90])
        translate([width/4,0,0])      // move 1/2 way to the edge
        screwhole(length=width/2);
        
        // Power supply pocket
        rotate([90,0,0])    // stand upright
        rotate([0,-45,0])   // align to face
        translate([0,(height/2)-pocketDepth/2+0.001,0]) // move to top
        translate([0,0,pocketHeight/2]) // align front of pocket with face
        translate([0,0,mountDepth])     // move back by mount depth
        translate([0,0,cablepocketFrontWallThickness]) // leave some material
        cube([pocketWidth,pocketDepth,pocketHeight],center=true);
  
      
        // hole for 12v power plug
        color("blue")
        translate([0,0,height/2])                 // move to top
        rotate(45)                                // make future moves in-line with the face
        translate([-powerplugDiameter/2,0,0])     // align front edge with the face
        translate([-mountDepth,0,0])              // move back by mount depth
        translate([-pocketHeight,0,0])            // move back by cable pocket depth
        translate([-powerplugWallThickness,0,0])  // move back from power pocket
        translate([0,0,-cablepocketDepth/2])      // sink into power cable pocket
        translate([0,0,0.001])                    // ensure it protrudes the surface
        cylinder(h=cablepocketDepth, r=powerplugDiameter/2, center=true);

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
       
        // Wall corner relief
        rotate(45)
        translate([-height,0,0])
        translate([wallCornerRelief,0,0])
        cube(height, center=true);

    }
    rotate(-45)
    translate([0,-10,0])
    sphere(29);
}
        
// Drywall screw head diameter: 8mm
// Drywall screw thread diameter: 4mm
// Wood screw head diameter: 10mm
// Wood screw thread diamter: 5mm
// head depth of both: 5.2mm
screwThreadDiameter = 4;
screwheadDiameter = 8;
screwheadDepth = 5.2;
module screwhole(length) {

    translate([0,0,-(width+screwheadDepth-length/2)])  // move to flush with wall
    translate([0,0,3])  // bring screwhead back surface
    {
    // create the screw hole
    cylinder(length,screwThreadDiameter/2,screwThreadDiameter/2,center=true);
    
    // countersink for screwhead
    translate([0,0,(length/2)+screwheadDepth/2]) // move countersink to end of screw
    translate([0,0, -0.001]) // ensure these cylinders overlap
    cylinder(h=screwheadDepth,r1=screwThreadDiameter/2,r2=screwheadDiameter/2,center=true);
    
    // ensure access to the screwhead
    translate([0,0,length+screwheadDepth])
    translate([0,0, -0.002]) // ensure these cylinders overlap    
    cylinder(h=length,r=screwheadDiameter/2,center=true);
    }
    
    // TODO size and countersink holes
}