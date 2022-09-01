thickness = 5;
ext = 30;
x = thickness*2;

plank_thickness = 17;

linear_extrude(height=30+thickness) body();
linear_extrude(height=thickness) base();

module body() {
    half_body();
    mirror([0, 1]) half_body();
    
    module half_body() {
    polygon([[0,0],  [0, thickness+plank_thickness/2+ext], [thickness, thickness+plank_thickness/2+ext], [thickness, thickness+plank_thickness/2], [thickness+plank_thickness, thickness+plank_thickness/2],
         [thickness+plank_thickness, thickness+plank_thickness/2+ext], [thickness+plank_thickness+thickness, thickness+plank_thickness/2+ext],
         [thickness+plank_thickness+thickness+x, plank_thickness/2 + thickness+x],
         [thickness+plank_thickness+ext, plank_thickness/2 + thickness], [thickness+plank_thickness+ext, plank_thickness/2], [plank_thickness+thickness*2, plank_thickness/2],
         [plank_thickness+thickness, plank_thickness/2], [plank_thickness+thickness, 0]]);
    }
}

module base() {
    half_base();
    mirror([0, 1]) half_base();
    
    module half_base() {
    polygon([[0,0],  [0, thickness+plank_thickness/2+ext],
         [thickness+plank_thickness, thickness+plank_thickness/2+ext], [thickness+plank_thickness+thickness, thickness+plank_thickness/2+ext],
         [thickness+plank_thickness+thickness, plank_thickness/2 + thickness],
         [thickness+plank_thickness+ext, plank_thickness/2 + thickness], [thickness+plank_thickness+ext, 0],
         [plank_thickness+thickness, 0]]);
    }
}