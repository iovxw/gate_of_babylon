// From: SFF-8301 3.5" Form Factor Drive Dimensions
// https://members.snia.org/document/dl/25861
// https://support.wdc.com/images/kb/2579-771970-A03.pdf
// a[1] = 17.8 or 26.1 or 42
$hdd__a = [0, 26.1,  147,   101.6, 95.25, 3.18,
              44.45, 41.28, 28.5,  101.6, 6.35,
              0.25,  0.5,   76.2];
$hdd__de_facto_side_hole = 41.61;
$hdd__width = $hdd__a[3];
$hdd__length = $hdd__a[2];
$hdd__height = $hdd__a[1];

hdd_foot();

module hdd_void() {
    a = $hdd__a;
    de_facto_side_hole = $hdd__de_facto_side_hole;
    width = $hdd__width;
    length = $hdd__length;
    height = $hdd__height;
    
    screw_d = 3.5;
    screw_h = 1;
    screw_head_d = 6.8;
    screw_head_h = 10;
    cube([a[3], a[2], a[1]]);
    
    module screw() {
        cylinder(d = screw_d, h = screw_h, $fn = 20);
        translate([0, 0, screw_h]) cylinder(d = screw_head_d, h = screw_head_h, $fn = 50);
    }
    module bottom_screw() rotate([180, 0, 0]) screw();
    translate([a[5], a[7]]) bottom_screw();
    translate([a[5], a[7] + a[6]]) bottom_screw();
    translate([a[5], a[7] + a[13]]) bottom_screw();
    translate([a[5] + a[4], a[7]]) bottom_screw();
    translate([a[5] + a[4], a[7] + a[6]]) bottom_screw();
    translate([a[5] + a[4], a[7] + a[13]]) bottom_screw();
    
    module left_screw() translate([0, 0, a[10]]) rotate([0, -90, 0]) screw();
    translate([0, a[8], 0]) left_screw();
    translate([0, a[8] + de_facto_side_hole, 0]) left_screw();
    translate([0, a[8] + a[9], 0]) left_screw();
    module right_screw() translate([width, 0, a[10]]) rotate([0, 90, 0]) screw();
    translate([0, a[8], 0]) right_screw();
    translate([0, a[8] + de_facto_side_hole, 0]) right_screw();
    translate([0, a[8] + a[9], 0]) right_screw();
}

module hdd_foot() {
    a = $hdd__a;
    width = $hdd__width;
    length = $hdd__length;
    height = $hdd__height;
    
    x_thickness = 3;
    y_thickness = 3;
    locator_thickness = 1;
    rubber_feet_d = 8 + 0.2;
    rubber_feet_h = 0.7;

    module foot() translate([10/2-x_thickness, 0, 0]) difference() {
        hull() {
            translate([10/2, 0, a[10]]) rotate([0, -90, 0]) cylinder(d = 10, h = 10, $fn = 80);
            translate([0, 0, -y_thickness]) cylinder(d = 10, h = 1, $fn = 100);
        }
        translate([0, 0, -y_thickness]) cylinder(d = rubber_feet_d, h = rubber_feet_h, $fn = 50);
    }

    difference() {
        translate([0, a[8], 0]) foot();
        #hdd_void();
    }
}