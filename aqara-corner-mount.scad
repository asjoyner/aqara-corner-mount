$fa = 1;
$fs = 0.4;
height=54;
difference(){
    cube([38.18377, 38.18377, height]);

    // cube that flattens the front
    rotate([0,0,45])
    translate([27,-28,-1])
    cube(height+2);

    // cylinder the base mounts into
    cyoffset=18;
    translate([cyoffset,cyoffset,27])
    rotate([90,0,135])
    cylinder(h=27, r=24.5);
    
    // screw hole
    rotate([90,0,90])
    translate([30,height/2,-2])
    cylinder(35,2,2);
    
    // screw hole
    rotate([90,0,0])
    translate([30,height/2,-32])
    cylinder(35,2,2);
    // TODO size and countersink holes
    
    // Power supply pocket
    pocketH=25;
    pocketW=30;
    rotate([90,0,-45])
    translate([-pocketH/2,24.5,-24])
    cube([pocketH,pocketW,10]);
    
    // Cable pocket
    cpH=10;
    cpW=30;
    rotate([90,0,-45])
    translate([-cpH/2,24.5,-14.001])
    cube([cpH,cpW,7]);
}

