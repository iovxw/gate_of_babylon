# %%
from build123d import *
from ocp_vscode import *
set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
with BuildPart() as holder:
    # 34.5 33, 14
    # 11 
    with BuildSketch() as bottom:
        Rectangle(33, 11)
        fillet(bottom.edges().sort_by(Axis.Y).last.vertices(), radius=10)
        fillet(bottom.edges().sort_by(Axis.Y).first.vertices(), radius=1)

    with BuildSketch(Plane.XY.offset(14)) as top:
        Rectangle(34, 11)
        fillet(top.edges().sort_by(Axis.Y).last.vertices(), radius=10)
        fillet(top.edges().sort_by(Axis.Y).first.vertices(), radius=1)
    inner = loft(mode=Mode.PRIVATE)
    with BuildSketch():
        offset(bottom.sketch,amount=2)
    with BuildSketch(Plane.XY.offset(14)):
        offset(top.sketch,amount=2)
    loft()
    add(inner, mode=Mode.SUBTRACT)
    with BuildSketch(Plane.XZ.offset(11/2)) as opening:
        add(inner.faces().sort_by(Axis.Y).first)
        x=opening.edges().filter_by(Axis.Y)
        show(x)
    extrude(until=Until.LAST, mode=Mode.SUBTRACT)

show(holder)

# %%
