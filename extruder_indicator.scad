$fn=100;
cylinder(h=3.5,r=2);
translate([0,0,-1]) cylinder(h=1,r=4);
translate([-1.5,0,-1]) cube([3,23,1]);
translate([1.5,1.808,-1]) difference() {
    translate([0,1,0]) cube([4,3,1]);
    translate([4,4,0]) cylinder(h=1,r=4);
}
mirror([1,0,0]) translate([1.5,1.808,-1]) difference() {
    translate([0,1,0]) cube([4,3,1]);
    translate([4,4,0]) cylinder(h=1,r=4);
}


translate([0,0,-1]) difference() {
    cylinder(h=1,r=21);
    cylinder(h=1,r=21-1);
}
