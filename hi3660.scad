w=80-0.6;
thickness = 0.5;

top();
//bottom();

module bottom() {
    difference() {
        union() {
        half(13);
        translate([w, 0]) mirror([1, 0]) half(13);
    }
    translate([w/2, 3, -thickness-1]) type_c(thickness+2);
    
    }
}
module top() {
    difference() {
        union() {
            half(10);
            translate([w, 0]) mirror([1, 0]) half(10);
        }
        translate([56.5, 3+3.5/2, -thickness-1]) cylinder(d=5, h = thickness+2, $fn=50);
        
        /*translate([w/2, 0, 5]) rotate([90, 0]) linear_extrude(height=thickness) offset(r=2, $fn=50) offset(delta=-2) 
            polygon([[-13/2, 0], [13/2, 0], [(13+8)/2, 10], [-(13+8)/2, 10]]);*/
    }
}

module half(h) difference() {
    intersection() {
        minkowski() {
            half_inner(h);
            sphere(d=thickness*2, $fn=20);
        }
        translate([-thickness, -thickness, -thickness]) cube([w/2+thickness, 100, h+thickness]);
    }
    half_inner(h);
}


module half_inner(h) {
        intersection() {
            linear_extrude(height=h) polygon([[0, 1], [0, 6-0.8],[1, 6], [3, 6.5], [4, 6.75], 
             [6, 7.1], [12, 7.8], [15, 7.9],  
             [30, 8.3], [w/2, 8.3], [w/2, 0], [1, 0]]);

            difference() {
                translate([0, 3+1, 20-3]) rotate([0, 90]) cylinder(r=20, h=w, $fn=4);
                corner($fn=50);
            }
        }
}

module corner() difference() {
    cube([5, 10, 5]);
    translate([5, 0, 5]) rotate([-90, 0]) intersection() {
        cylinder(r=5, h=10);
        translate([0, 0, -4]) cylinder(r1=0, r2=10*10, h=10*10);
    }
}

module type_c(h) translate([2.83/2-8.55/2, 2.83/2]) hull() {
    $fn=30;
    cylinder(d=2.83,h=h);
    translate([8.55-2.83, 0]) cylinder(d=2.83, h=h);
 }