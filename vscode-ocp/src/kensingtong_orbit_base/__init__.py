# %%
import math

from build123d import *
from ocp_vscode import *

set_defaults(reset_camera=Camera.KEEP)

# %%
wall_thickness = 1.5
infill_thickness = 1.5
infill_hex_d = 10
loc = Location((0, 0, 17), (0, -10, 0))

hole_y_pos = 47.7
hole_r = 15 / 2
circle_outer_r = 52 / 2
circle_inner_r = 32.5 / 2

x_pts = [87.6, 81.3, 73.5, 63.5, 51.2]
joint_thickness = 1
bottom_joint_height = 2
x_offset = (joint_thickness + 0.2) / 2
pts = [(x / 2 + x_offset, i * -10) for i, x in enumerate(x_pts)]
s1 = Spline(*pts)
s2 = Spline(*[(-x, y) for x, y in pts])

with BuildSketch() as bottom_joint:
    SlotArc(s1, joint_thickness)
    SlotArc(s2, joint_thickness)
with BuildSketch() as top_joint:
    with Locations((0, hole_y_pos)):
        Circle(hole_r)
        Circle(hole_r - joint_thickness, mode=Mode.SUBTRACT)
show(top_joint, bottom_joint)

# %%

# 40 6.6 8.3
s3 = SagittaArc((-40 / 2 + 6.6 / 2, 0), (40 / 2 - 6.6 / 2, 0), -(8.3 - 6.6))
s3_y_offset = -38.9 - 6.6 / 2

with BuildSketch() as base_sk:
    add(bottom_joint)
    add(top_joint)
    with BuildSketch():
        with Locations(Location((0, hole_y_pos,0))):
            Circle(circle_outer_r)
            Circle(circle_inner_r, mode=Mode.SUBTRACT)
    with Locations((0, s3_y_offset)):
        SlotArc(s3, 5 + 1 * 2)
show(base_sk)

# %%
with BuildSketch() as body_sk:
    add(base_sk.sketch)
    make_hull()
    with Locations(Location((0, hole_y_pos))):
        Circle(hole_r, mode=Mode.SUBTRACT)
with BuildSketch() as wall_sk:
    add(body_sk)
    offset(body_sk.sketch.face().outer_wire(), amount=-wall_thickness)
    make_face(mode=Mode.SUBTRACT)
show(wall_sk)

# %%
x_n = math.floor(body_sk.sketch.bounding_box().size.X/infill_hex_d*1.5)
y_n = math.floor(body_sk.sketch.bounding_box().size.Y/infill_hex_d*1.5)
with BuildSketch() as infill_sk:
    with HexLocations(infill_hex_d/2, x_n, y_n):
        RegularPolygon(infill_hex_d/2, 6, major_radius=False)
        RegularPolygon(infill_hex_d/2-infill_thickness/2, 6, major_radius=False, mode=Mode.SUBTRACT)
    add(body_sk, mode=Mode.INTERSECT)
show(infill_sk)

# %%
with BuildPart() as base:
    with BuildPart(loc):
        add(bottom_joint.sketch)
        extrude(amount=bottom_joint_height + 0.5)
        with BuildSketch(loc):
            add(top_joint.sketch)
        extrude(amount=5)
        f = add(base_sk.sketch+infill_sk.sketch+wall_sk.sketch)
    extrude(f, dir=(0, 0, -1), amount=base.part.bounding_box().size.Z * 2)
    split(bisect_by=Plane.XY)
show(base)
base.part.export_stl("/tmp/base.stl")
