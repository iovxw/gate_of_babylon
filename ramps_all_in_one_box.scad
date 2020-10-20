$fn=20;


/*linear_extrude(height=0.2) difference() {
    hull() {
        circle(d=3+2);
        translate([0, 80]) circle(d=3+2);
    }

    circle(d=3);
    translate([0, 80]) circle(d=3);
}*/


thickness=1.0;

length=43;
width=25;
height=99;

//16
difference() {
    translate([0, 0, -thickness]) linear_extrude(height=height+thickness*2) polygon([
        [-thickness, -thickness],
        [-thickness, width], 
        [length+thickness, 43-50/2-1],
        [length+thickness, -thickness]
    ]);
    cube([length, width, height]);
    translate([-thickness, 16+2, (height-80)/2]) rotate([0, 90, 0]) cylinder(d=3, h=10);
    translate([-thickness, 16+2, height-(98-80)/2]) rotate([0, 90, 0]) cylinder(d=3, h=10);
    translate([43, 43, height-36]) rotate([0, 90, 0]) cylinder(d=50, h=10);
}
