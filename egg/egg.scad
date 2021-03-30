$fn = 30;

height = 60;
thickness = 2;

rotate_extrude() difference() {
    scale(height/600) import("egg.svg", convexity=3);
    //translate([0, thickness]) scale((height-thickness*2)/600) import("egg.svg", convexity=3);
}