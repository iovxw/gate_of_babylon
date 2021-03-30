thickness = 0.8;
w = 51;
h = 61;

a();
//b();
//b(true);

module a() {
    translate([0, 0, 10]) {
        linear_extrude(height=5) difference() {
            body(w, h);
            offset(r=-thickness) body(w, h);
            translate([0, (h-(12+1))/2]) square([thickness+w, 12+1]);
            translate([(w-(12))/2, 0]) square([12, thickness+h]);
        }
        translate([0, (h-12)/2]) cube([thickness, 12, 5+6-0.4]);
        translate([0-1.5, (h-12)/2, 5+0.3]) clip();
        translate([w-thickness, (h-12)/2]) cube([thickness, 12, 5+6-0.4]);
        translate([w+1.5, (h-12)/2, 5+0.3]) mirror([1, 0]) clip();
    }

    module clip()  difference() {
        cube([thickness+1.5, 12, 6-0.3]);
        translate([-3, 0]) rotate([0, 14]) cube([3, 12, 10]);
    }

    translate([0, 0, 10-3]) linear_extrude(height=3) difference() {
        offset(r=1.5) body(w, h);
        offset(r=-thickness) body(w, h);
    }

    linear_extrude(height=10) difference() {
        offset(r=1.5) body(w, h);
        offset(r=-thickness) body(w, h);
    }

    linear_extrude(height=thickness) difference() {
        offset(r=1.5) body(w, h);
        translate([w/2, h/2]) circle(d=30);
    }
}

module b(hole) difference() {
    $fn=100;
    union() {
        translate([0, 0, thickness+3]) cylinder(d1=30, d2=28, h=10);
        cylinder(d=30, h=thickness+3);
        cylinder(d=30+5, h=thickness);
    }
    if(hole) {
        cylinder(d1=30-thickness*2, d2=28-thickness*2, h=thickness+3+10);
    }
}

module body(w, h) {
    translate([w, h]) corner();
    translate([0, h]) mirror([1, 0]) corner();
    translate([w, 0]) mirror([0, 1]) corner();
    mirror([0, 1]) mirror([1, 0]) corner();
    translate([5, 0]) square([w-10, h]);
    translate([0, 5]) square([w, h-10]);
    //square([w, h]);
}

module corner() translate([-5-4.3, -5-7-11/2]) {
    translate([5, 5]) hull() {
        translate([-0.5, 7]) circle(d=11, $fn=40);
        translate([3, 2.5]) circle(d=4, $fn=40);
        square([4.3, 1]);
    }
    
    square([5+4.3, 10]);
    square([5-0.5, 5+7+11/2]);
}