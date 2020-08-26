$fn=100;

width=11;
length=20;

belt_thickness=1.5; // 1.38
merged_belt_thickness=2;
belt_width=6;
circle_d=7;

main(7, 2.5);
//main(8, 8.5);

module main(height1, height2) {
    difference() {
        translate([-width/2, 0, 0]) cube([width, length, height1]);
        translate([0, 12.5, 0]) belt();
        translate([0, 4.5, 0]) cylinder(d=4, h=99, $fn=6);
    }
    translate([-width/2, length-8, height1]) cube([width, 8, height2]);
}


module belt() {
    magic_width=circle_d/2+merged_belt_thickness/2;
    magic_height=sqrt(pow(circle_d, 2)-pow(magic_width, 2));
    linear_extrude(height=belt_width) shell(-1.5) {
        difference() {
            union() {
                circle(d=circle_d);
                translate([-(magic_width)/2, 0]) square([magic_width, magic_height]);
            }
            translate([magic_width, magic_height]) circle(d=circle_d);
            mirror([1, 0]) translate([magic_width, magic_height]) circle(d=circle_d);
        }
        translate([-merged_belt_thickness/2, 0]) square([merged_belt_thickness, 10]);
    }
}


// Copyright (c) 2013 Oskar Linde. All rights reserved.
// License: BSD
//
// This library contains basic 2D morphology operations
//
// outset(d=1)            - creates a polygon at an offset d outside a 2D shape
// inset(d=1)             - creates a polygon at an offset d inside a 2D shape
// fillet(r=1)            - adds fillets of radius r to all concave corners of a 2D shape
// rounding(r=1)          - adds rounding to all convex corners of a 2D shape
// shell(d,center=false)  - makes a shell of width d along the edge of a 2D shape
//                        - positive values of d places the shell on the outside
//                        - negative values of d places the shell on the inside
//                        - center=true and positive d places the shell centered on the edge

module outset(d=1) {
	// Bug workaround for older OpenSCAD versions
	if (version_num() < 20130424) render() outset_extruded(d) children();
	else minkowski() {
		circle(r=d);
		children();
	}
}

module outset_extruded(d=1) {
   projection(cut=true) minkowski() {
        cylinder(r=d);
        linear_extrude(center=true) children();
   }
}

module inset(d=1) {
	 render() inverse() outset(d=d) inverse() children();
}

module fillet(r=1) {
	inset(d=r) render() outset(d=r) children();
}

module rounding(r=1) {
	outset(d=r) inset(d=r) children();
}

module shell(d,center=false) {
	if (center && d > 0) {
		difference() {
			outset(d=d/2) children();
			inset(d=d/2) children();
		}
	}
	if (!center && d > 0) {
		difference() {
			outset(d=d) children();
			children();
		}
	}
	if (!center && d < 0) {
		difference() {
			children();
			inset(d=-d) children();
		}
	}
	if (d == 0) children();
}


// Below are for internal use only

module inverse() {
	difference() {
		square(1e5,center=true);
		children();
	}
}