difference() {
union() { translate([0,-7,0]) difference() {
translate([-2.5,-2.5,0]) cube([20+2.5*2,20+2.5,6]);
cube([20,200,6]);
}
translate([0,(20-6)/2,0]) cube([1.5,6,6]);
translate([20-1.5,(20-6)/2,0]) cube([1.5,6,6]);
translate([0,-7,0]) cube([20,7,6]);
//translate([0,-7,0]) cube([(20-7*2)/2,7,6]);
//translate([20-(20-7*2)/2,-7,0]) cube([(20-7*2)/2,7,6]);
}

o=0.5;
translate([20/2+7/2,-7/2,0]) cylinder(r=(7+o)/2, h=6);
translate([20/2-7/2,-7/2,0]) cylinder(r=(7+o)/2, h=6);
w=6;
translate([20/2-w/2,-7+5/2,0]) cube([w,5,6]);
}