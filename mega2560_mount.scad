pcb=[53.34, 101.6, 1.65];
pcb_bottom_space=2.5;
hole=[pcb[0]-2.54, 96.52];
thickness=5;
solt_depth=1;
x=(pcb[1]-hole[1])*2-5;

$fn=50;

//translate([0, 0, pcb_bottom_space]) cube(pcb);
difference() {
    union() {
        main();
        //translate([hole[0], hole[1], pcb_bottom_space+pcb[2]]) cylinder(d=7, h=2);  
    }
    translate([hole[0], hole[1], -thickness]) cylinder(d=2.5, h=thickness);
}

module main() {
translate([(pcb[0]-10)/2+10, 0, -thickness]) cube([10, pcb[1]+thickness-solt_depth, thickness]);
translate([(pcb[0]-10)/2+10, pcb[1], 0]) holder();

//translate([pcb[0]-10, 0, -thickness]) cube([10, pcb[1]+thickness-solt_depth, thickness]);
//translate([pcb[0]-10, pcb[1], 0]) holder();

translate([-20, x-solt_depth, -thickness]) difference() {
    cube([20+pcb[0]+thickness-solt_depth, 10, thickness]);
    translate([20/2, 10/2, 0]) cylinder(d=5+0.3, h=thickness);
}
translate([0, x-solt_depth, 0]) rotate([0, 0, 90]) holder();
translate([pcb[0], x-solt_depth, 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) holder();

translate([-20, (pcb[1]+thickness)-10-x, -thickness]) difference() {
    cube([20+pcb[0]+thickness-solt_depth, 10, thickness]);
    translate([20/2, 10/2, 0]) cylinder(d=5+0.3, h=thickness);
}
translate([0, (pcb[1]+thickness)-10-x, 0]) rotate([0, 0, 90]) holder();
translate([pcb[0], (pcb[1]+thickness)-10-x, 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) holder();
}

module holder() translate([0, -solt_depth, 0]) {
    difference() {
        cube([10, thickness, pcb_bottom_space+pcb[2]+2]);
        translate([0, 0, pcb_bottom_space])
            cube([10, solt_depth, pcb[2]]);
    }
    // support
    #translate([0, 0, pcb_bottom_space+0.2])
        cube([10, 0.4+0.1, pcb[2]-0.2*2]);
}