solt_d1=14.1-0.5;
solt_d2=4.4-0.5;
solt_depth=5.5;
solt_width=6.4;

t_nut();
//bolt();

module t_nut() {
    difference() {
        translate([0, 0, solt_width/2]) union() {
            main();
            convex();
        }
        translate([0, 3.5, solt_width/2]) rotate([90, 0, 0]) screw();
    }
    
    module main() {
        rotate([0, 180, 0]) half();
        half();
        
        /// 1/4
        module part() intersection() {
            rotate([-90, 0, 0]) union() {
                translate([0, 0, 0.5]) cylinder(d2=solt_d2, d1=solt_d1, h=solt_depth-0.5, $fn=100);
                cylinder(d=solt_d1, h=0.5, $fn=100);
            }
            translate([0, 0, -solt_width/2]) cube([solt_d1/2, solt_depth, solt_width/2]);
        }

        /// 1/2
        module half() {
            linear_extrude(height=solt_width/2) projection() part();
            part();
        }
    }
    
    module convex() {
        rotate([90, 0, 0]) cylinder(d=solt_width, h=1, $fn=50);
        intersection() {
            translate([-solt_width/2, -1, -solt_width/2]) cube([solt_width, 1, solt_width]);
            rotate([0, 45, 0]) cube([sin(45)*solt_width, 99, 99], center=true);
        }
    }

    module screw() {
        $fn=50;
        translate([0, 0, -10]) cylinder(d=100, h=10);
        cylinder(d1=7.6, d2=3, h=3);
        cylinder(d=3, h=10);
    }
}

module bolt() difference() {
    $fn=20;
    cylinder(d=9, h=8, $fn=6);
    cylinder(d=3, h=7);
}