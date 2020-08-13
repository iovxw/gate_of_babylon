slot_width=6.5;
slot_thickness=2;
t_depth=0;
trap_bot_width=14.5;
trap_top_width=6;
trap_depth=4.3;

extrusion_width=20;
cover_thickness=2;
corner_rounding=2;
hole_size=0;

tab_height=6;

difference() {
	union() {
		for (a=[0:3])
			rotate([0,0,90*a])
				translate([0,-extrusion_width/2,0])
					difference() {
                        t_slot();
                        translate([0,0,9.1]) rotate([45,0,0]) cube([20,10,10],true);
                    }
		
		translate([-extrusion_width/2+corner_rounding, -extrusion_width/2+corner_rounding,0])
			minkowski() {
				cube([extrusion_width-corner_rounding*2,extrusion_width-corner_rounding*2,cover_thickness-1]);
				cylinder(r=corner_rounding, h=1, $fn=16);
			}
	}
	cylinder(r=hole_size/2, h=cover_thickness*4, center=true);
}

module t_slot() {
	translate([-slot_width/2,0,0])
		cube([slot_width, slot_thickness+t_depth, tab_height]);
	translate([0,slot_thickness+t_depth,0])
		linear_extrude(height=tab_height)
			trapezoid(bottom=trap_bot_width, top=trap_top_width, height=trap_depth);
	translate([0,slot_thickness+t_depth+trap_depth,cover_thickness+1])
        cylinder(tab_height-cover_thickness-1, r=0.5,center=false);
}


module trapezoid(bottom=10, top=5, height=2)
{
	polygon(points=[[-bottom/2,0],[bottom/2,0],[top/2,height],[-top/2,height]]);
}
