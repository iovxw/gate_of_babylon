sizes1 = [10, 8, 6, 5];
sizes2 = [4, 3.5, 3, 2.5, 2, 1.5];

fit = 0.1;

$fn = 100;

difference() {
    translate([10/2+2, -10/2-5, 0]) rotate([0,-90,0])
        linear_extrude(height = 10+2*2)
        offset(r=3) offset(delta=-3)
        polygon([[0,0], [30+10,0], [20+10, 10+8+6+5+(10+5)], [0, 10+8+6+5+(10+5)]]);
    translate([0, 0, 1]) hole(sizes1);
}
difference() {
    translate([10+3, -10/2-5, 0]) rotate([0,-90,0])
        linear_extrude(height = 4+2)
        offset(r=3) offset(delta=-3)
        difference() {
            polygon([[0,0], [30,0], [20, 10+8+6+5+(10+5)], [0, 10+8+6+5+(10+5)]]);
            //polygon([[0,0+35], [30,0+35], [20, 10+8+6+5+(10+5)], [0, 10+8+6+5+(10+5)]]);
        }
    translate([10, -2, 1]) hole(sizes2);
}
module hole(l) for(x = [for(i = [0 : len(l) - 1]) [i, l[i]]]) {
    y = (sum(select(l, [0 : x[0]-1]))+1*x[0]);
    translate([0, y, 0]) hex_key(d=x[1]+fit, h=80);
}

module hex_key(d,h) cylinder(r=d/sqrt(3), h=h, $fn=6);

function sum(v) = [for(p=v) 1]*v;
function select(vector,indices) = [ for (index = indices) vector[index] ];