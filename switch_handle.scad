difference() {
    cube([51, 16.5, 5], center = true);
    r = 500;
    translate([0, 0, -r]) sphere(r = r, $fn = r);
}
translate([0, 0, 40/2]) cube([10, 16.5, 40], center = true);
difference() {
    translate([0, 0, 6.5]) cube([10*2+10/2+6, 16.5, 12], center = true);
    $fn = 300;
    translate([10+10/2, 0, 10+5/2]) rotate([90, 0, 0]) cylinder(h = 100, r = 10, center = true);
    translate([-10-10/2, 0, 10+5/2]) rotate([90, 0, 0]) cylinder(h = 100, r = 10, center = true);
}