# %%
import math
from build123d import *
from ocp_vscode import *

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
# 12 30 2.5+0.5 4 18

screw_d = 5-0.6
a = 2.5 + 0.5
b = 4
c = 18
d = 13
rod_d = 12+0.1

#                  a
#                  ▲
#                  │
#                 ┌─┐─┐
#                 │ │ ▼
#       screw_d   │ │ b
#          ▲      │ │ ▲
#          │      │ │ │
# ┌───────┬─┬─────┘ │─┘
# └───────┴─┴───────┘
# │        └► d ◄───┤
# └──────► c ◄──────┘
#
# ┌───────┬─┬──────────────┬─┬───────┐
# └───────┴─┴──────────────┴─┴───────┘
# %%
thickness = 4
groove_n = 10
groove_depth = 1

with BuildPart() as connector:
    with BuildSketch(Plane.XZ):
        Rectangle(c + thickness, 10 + b, align=(Align.MAX, Align.MAX))
        with Locations((-7, 0)):
            Circle(rod_d / 2 + thickness+groove_depth)
            Circle(rod_d / 2, mode=Mode.SUBTRACT)
            for i in range(groove_n):
                Rectangle(1, rod_d/2+groove_depth, rotation=360/groove_n*i,mode=Mode.SUBTRACT, align=(Align.CENTER, Align.MIN))
        with Locations((-thickness, -10)):
            Rectangle(a, b, align=(Align.MAX, Align.MAX), mode=Mode.SUBTRACT)
    extrude(amount=55 / 2, both=True)
    screw_locs = Locations((-d - thickness, 30 / 2), (-d - thickness, -30 / 2))
    with screw_locs:
        Hole(screw_d / 2)
    #with screw_locs:
    #    with Locations((0.5, 0)):
    #        Hole(screw_d / 2, depth=2)
    holes = connector.faces().sort_by(Axis.Z).first.edges().filter_by(GeomType.CIRCLE)
    chamfer(holes, 0.3, 1)

show(connector)
connector.part.export_step("/tmp/connector.step")
# %%
with BuildPart() as install_helper:
    with BuildSketch():
        Rectangle(100, 20, align=(Align.CENTER, Align.MIN))
        with Locations((65/2, 0), (-65/2,0)):
            Rectangle(12, 12, align=(Align.CENTER, Align.MIN), mode=Mode.SUBTRACT)
    extrude(amount=20)
show(install_helper)
install_helper.part.export_step("/tmp/install_helper.step")