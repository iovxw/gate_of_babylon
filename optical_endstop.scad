$fn=50;

end_stop=[25, 10];

//a();
b();
//mirror([0, 1, 0]) c();

module a() {
    difference() {
        mirror([0, 1, 0]) rotate([90, 0, 0]) difference() {
            cube([end_stop[0], end_stop[1], 5+10]);
            translate([(end_stop[0]-19)/2, end_stop[1]/2]) cylinder(d=3, h=5);
            translate([end_stop[0]-(end_stop[0]-19)/2, end_stop[1]/2]) cylinder(d=3, h=5);
            translate([(end_stop[0]-12)/2, 1]) cube([12, end_stop[1]-1*2, 2]);
        }
    
        translate([end_stop[0]/2, 10/2+5]) cylinder(d=3, h=99);
        translate([end_stop[0]/2, 10/2+5]) cylinder(d=7, h=7);
        translate([end_stop[0]-6/2, 10/2+5]) resize([10, 5, 99]) cylinder(d=6, h=99, $fn=3);
        translate([0, 5]) cube([end_stop[0]/2-10/2, 10, 10]);
    }
}

module b() {
    h=30;
    difference() {
        union() {
            translate([end_stop[0]/2-10/2, 0, h]) cube([end_stop[0]/2+10/2, 10, 5]);
            translate([end_stop[0]-6/2, 10/2]) resize([10, 5, h]) cylinder(d=6, h=99, $fn=3);
            translate([end_stop[0]-4, 0, h]) cube([4, 10, 30]);
            translate([end_stop[0]/2, 10/2, h-2]) cylinder(d=7, h=2);
        }
        translate([end_stop[0], 0]) cube([99, 99, 99]);
        translate([end_stop[0]/2, 10/2]) cylinder(d=3+0.5, h=99);
        translate([end_stop[0]-5, (10-5)/2, h+5]) cube([5, 5, 30-5-5/2]);
    }
}

module c() {
    solt_width=6.4;
    cube([7, 2, 20+30]);
    difference() {
        hull() {
            cube([7, 2, 20]);
            translate([-5, 0, 0]) cube([5, 20, 20]);
        }
        translate([0, 20-7, 20/2]) rotate([0, -90, 0]) m5_screw();
    }
    translate([-5-3, 0, (20-solt_width)/2]) cube([3, 20-7*2, solt_width]);
}

module m5_screw() {
    cylinder(d=5, h=10);
    translate([0, 0, -10]) cylinder(d=8, h=10);
}