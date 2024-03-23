$fa = 1;
$fs = 0.4;
height=75; // working in mm
width=height/sqrt(2);
mountDepth=3;
mountRadius=24.75;  // set to 24.5 for a tight friction fit
faceBrimWidth=2;
faceRadius=mountRadius+faceBrimWidth;
rearRadius=6;
rearConeDepth=height;

powerGroupHeight=height/2-20;

pocketFrontWallThickness=.75;
pocketDepth=30;  // when viewed from the top, how far down does the pocket extend
pocketWidth=16;  // when viewed from the top, how wide is the pocket
pocketHeight=10; // when viewed from the top, how "tall" is the pocket

cablepocketFrontWallThickness=6;
cablepocketDepth=30;  // when viewed from the top, how far down does the pocket extend
cablepocketWidth=10;  // when viewed from the top, how wide is the pocket
cablepocketHeight=8; // when viewed from the top, how "tall" is the pocket

powerplugDiameter=10.5;      // diameter of the 12v power plug
powerplugWallThickness=2;   // thickness of the material around the plug

wallCornerRelief=3;

// Drywall screw head diameter: 9mm
// Drywall screw thread diameter: 3mm
// Wood screw head diameter: 11mm
// Wood screw thread diamter: 5mm
// head depth of both: 5.2mm
screwThreadDiameter = 4;
screwheadDiameter = 9;
screwheadDepth = 5.2;   // distance from face of screw to start of threads

screwSeparation = 35;  // Distance between Aqara magnets
screwSeparationOnAngle = (screwSeparation/sqrt(2));  // distance between magnets in the 45 degree plane
screwOffsetFromCenter = screwSeparationOnAngle/2;
//screwOffset = screwOffsetFromCenter - (screwheadDepth/sqrt(2));
// best magnetic hold so far, Fatboy Proud Screws:
//screwOffset=5.25;
//screwDepth=14;
screwOffset=6.15;
screwDepth=12.25;
echo("screwOffset: ", screwOffset);  // determined to keep the screw 

overlap=0.001;  // overlap each side by 1mm

rotate(45)
intersection() {
    difference(){
        // Start with a cube of the right dimensions
        cube([width, width, height], center=true);

        // add a cube that flattens the front
        color("red")    
        rotate(45)                  // turn it so 
        translate([(height/2),0,0]) // slide it to cover the whole face
        cube([(height)+(overlap*2), height+(overlap*2), height+(overlap*2)], center=true);
        // carve out the cylinder the base mounts into
        rotate([90,0,-45])
        cylinder(h=mountDepth*2, r=mountRadius, center=true);

        // screw holes
        rotate([-90,0,0])
        translate([screwOffset,0,0])    // move towards to the edge
        screwhole(length=width/2);      // left screw, viewed from front
        rotate([90,0,90])
        translate([screwOffset,0,0])    // move towards to the edge
        screwhole(length=width/2);      // right screw, viewed from front
        
        // Power supply pocket
        rotate([90,0,0])    // stand upright
        rotate([0,-45,0])   // align to face
        translate([0,(powerGroupHeight)-pocketDepth/2+overlap,0]) // move to top
        translate([0,0,pocketHeight/2]) // align front of pocket with face
        translate([0,0,mountDepth])     // move back by mount depth
        translate([0,0,cablepocketFrontWallThickness]) // leave some material
        translate([0,-powerplugWallThickness,0])  // move down to match base
        cube([pocketWidth,pocketDepth+(powerplugWallThickness*2),pocketHeight],center=true);

        // hole for 12v power plug
        color("blue")
        translate([0,0,powerGroupHeight])                 // move to top
        translate([0,0,-cablepocketDepth/2])      // sink into power cable pocket
        rotate(45)                                // make future moves in-line with the face
        translate([-powerplugDiameter/2,0,0])     // align front edge with the face
        translate([-mountDepth,0,0])              // move back by mount depth
        translate([-cablepocketFrontWallThickness,0,0]) // leave some material
        translate([-pocketHeight,0,0])            // move back by cable pocket depth
        translate([-powerplugWallThickness,0,0])  // move back from power pocket        
        translate([0,0,-powerplugWallThickness])  // move down to match base
        translate([0,0,overlap])                  // ensure it protrudes the surface
        cylinder(h=cablepocketDepth+(powerplugWallThickness*2), r=powerplugDiameter/2, center=true);

        // pocket for power supply cable
        color("orange")
        rotate([90,0,0])    // stand upright
        rotate([0,-45,0])   // align to face
        translate([0,powerGroupHeight-cablepocketDepth/2,0]) // move to top
        translate([0,-powerplugWallThickness*1.5,0]) // move below power plug hole
        translate([0,0,cablepocketHeight]) // align front of pocket with face
        translate([0,0,mountDepth])   // move back by mount depth
        translate([0,0,pocketHeight])  // move back by cable pocket depth
        cube([cablepocketWidth,cablepocketDepth+(powerplugWallThickness),cablepocketHeight],center=true);
        
        // flatten the top of the power pocket(s)
        flattopDepth=20;
        flattopExtension=15;  // how far the flattop clips towards the corner of the wall
        flattopHeight=cablepocketFrontWallThickness+
                      pocketHeight+
                      powerplugWallThickness+
                      powerplugDiameter;
        rotate(135)
        translate([0,0,powerGroupHeight+flattopDepth/2]) // align bottom with powerGroupHeight
        translate([0,flattopExtension/2,0]) // shift the front half of the extension distance to the back
        translate([0,(flattopHeight/2),0])
        cube([height,(flattopHeight/2)+flattopExtension,flattopDepth],center=true);
       
        // Wall corner relief
        rotate(45)
        translate([-height,0,0])
        translate([wallCornerRelief,0,0])
        cube(height+overlap*2, center=true);

    }
    rotate(45)
    rotate([0,-90,0])
    cylinder(h=rearConeDepth,r1=faceRadius,r2=rearRadius);
}


module screwhole(length) {

    translate([0,0,-(width+screwheadDepth-(length/2))])  // move to flush with wall
    translate([0,0,screwDepth])                      // bring screwhead back surface
    {
    // create the screw hole
    cylinder(length,screwThreadDiameter/2,screwThreadDiameter/2,center=true);
    
    // countersink for screwhead
    translate([0,0,(length/2)+screwheadDepth/2]) // move countersink to end of screw
    translate([0,0, -overlap]) // ensure these cylinders overlap
    cylinder(h=screwheadDepth,r1=screwThreadDiameter/2,r2=screwheadDiameter/2,center=true);
    
    // ensure access to the screwhead
    translate([0,0,length+screwheadDepth])
    translate([0,0, -overlap*2]) // ensure both these cylinders overlap    
    cylinder(h=length,r=screwheadDiameter/2,center=true);
    }
}