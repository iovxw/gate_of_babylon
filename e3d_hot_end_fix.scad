// See https://www.thingiverse.com/thing:3203831

ptfe_tube_length = 42.5;

h = 2.5;

$fn=100;

difference(){
    union() {
        cylinder(d=9-0.2, h = h);
        translate([0, 0, h]) cylinder(d1 = 9-0.2, d2 = 4+1, h = 1.5);
    }
    translate([0, 0, h]) cylinder(d=4+0.5, h = 9.999);
    cylinder(d = 2+0.5, h = h);
    cylinder(d2 = 2+0.5, d1 = 4, h = 1);
}