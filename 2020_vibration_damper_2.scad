$fn=100;

damper(part="a");

module damper(d=20, height=10, thickness=1.5, part="b") {
    linear_extrude(height=height) {
        half();
        mirror([1, 0]) half();
    }
    translate([10-2, d, (10-6)/2]) cube([2, 10, 6]);
    mirror([1, 0, 0]) translate([10-2, d, (10-6)/2]) cube([2, 10, 6]);
    
    module half() difference() {
        union() {
            square([d, d]);
            translate([d, d/2]) circle(d=d);
            translate([10, d]) square([2, 10]);
            translate([10-2-2, d]) square([2, 10]);
        }
       translate([0, thickness*2]) square([d, d-thickness*4]);
       hull() {
           translate([height/2+1, thickness*2]) square([1, d-thickness*4]);
           translate([d, d/2]) circle(d=d-thickness*2);
       }
        
        if(part=="a") {
            square([height/2, thickness]);
            translate([0, d-thickness]) square([5, thickness]);
        } else {
            translate([0, thickness]) square([height/2, thickness]);
            translate([0, d-thickness*2]) square([5, thickness]);
        }
    }
}

/*
module half() {
    square([10, 7]);
    hull() {
        translate([10, 0]) square([10, 7]);
        translate([10+5/2, 20-5/2]) circle(d=5);
        translate([10+10-5/2, 5]) circle(d=5);
    }
}
*/

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