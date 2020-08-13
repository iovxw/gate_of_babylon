// 8.7
// 133.5

linear_extrude(height=0.3) difference() {
    hull() {
        circle(d=8.7+2);
        translate([133.5+8.7, 0]) circle(d=8.7+2);
    }
    circle(d=8.7);
    translate([133.5+8.7, 0]) circle(d=8.7);
}

difference() {
    cylinder(h=2, d2=8.3+2, d1=8.7+2);
    cylinder(h=2, d2=8.3, d1=8.7);
}

translate([133.5+8.7, 0]) difference() {
    cylinder(h=2, d2=8.3+2, d1=8.7+2);
    cylinder(h=2, d2=8.3, d1=8.7);
}