h=1.05;

$fn=50;

difference() {
    cylinder(d=8,h=h);
    cylinder(d=5, h=h);
    translate([-3/2, 2, 0]) cube(3);
}

t=1;

difference() {
    cylinder(d=10+t*2,h=h+1);
    translate([0, 0, h]) cylinder(d=10, h=1);
    cylinder(d=8, h=h);
    translate([-(10+t*2)/2, 2, 0]) cube(10+t*2);
}