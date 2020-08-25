thickness=3;

module x()
    linear_extrude(height=thickness)
    difference() {
        polygon([[0, 0], [0, 60], [20, 60], [20, 50], [50, 20], [60, 20], [60, 0]]);
        for(point=[10 : 14 : 50]) {
            $fn=20;
            translate([60-point, 20/2, 0]) circle(d=3);
            translate([20/2, 60-point, 0]) circle(d=3);
        }
    }

translate([-thickness, 0, 0]) rotate([0, 90, 0]) x();
translate([0, -thickness, 0]) rotate([-90, 0, 0]) x();

translate([-thickness, -thickness, -60]) cube([thickness, thickness, 60]);
    
    
/*
module tenon(length=10, solt_width=6.6, slot_thickness=1.55) {
    half();
    mirror([0, 0, 1]) half();
    
    module half() 
        rotate([90, 0, 90])
        linear_extrude(height=length)
        polygon(points=[
            [0, 3/2-0.5],
            [0, solt_width/2-0.2], 
            [slot_thickness, solt_width/2-1.5],
            [slot_thickness, solt_width/2],
            [5, solt_width/2],
            [5, 0+0.07],
            [5-4, 0+0.07]
        ]);
}

translate([20, 0, -20/2]) tenon(length=40);
translate([0, 20, -20/2]) mirror([1, 0, 0]) rotate([0, 0, 90]) tenon(length=40);
translate([20/2, 0, 0]) mirror([0, 0, 0]) rotate([0, 90, 0]) tenon(length=40+20);
translate([0, 20/2, 0]) rotate([0, 0, -90]) rotate([0, 90, 0]) tenon(length=40+20);
*/