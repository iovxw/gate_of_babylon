d1=50;
d2=120;
thickness=1;

$fn=8;

linear_extrude(height=20, twist=45, slices = 100) difference() {
    circle(d=d1);
    circle(d=d1-thickness*2);
}

translate([0, 0, 20]) difference() {
    linear_extrude(height=30, twist=50, slices = 100, scale=d2/d1) 
    circle(d=d1);
    
    linear_extrude(height=30, twist=50, slices = 100, scale=(d2-thickness*2)/(d1-thickness*2)) 
    circle(d=d1-thickness*2);
}
/*
difference() {
    cylinder(d=d1, h=20);
    cylinder(d=d1-thickness*2, h=20);
}
translate([0, 0, 20]) difference() {
    cylinder(d1=d1, d2=d2, h=30);
    cylinder(d1=d1-thickness*2, d2=d2-thickness*2, h=30);
}
*/