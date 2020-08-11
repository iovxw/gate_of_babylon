cube([12, 12, 2.5]);
translate([-1, 0, 0]) cube([1, 12+20, 2.5]);
translate([-80-20, 12+20-10, 0]) difference() {
    cube([80+20, 10, 2.5]);
    translate([1, 1, 0]) cube([80+20-2, 10-2, 2.5]);
}
//translate([-80, 12+20-10+10/2, 30]) rotate([0, 90, 0]) cylinder(h=1, d=10);