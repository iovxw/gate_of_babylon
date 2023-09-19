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
    outer = loft()
    add(inner, mode=Mode.SUBTRACT)
    opening_face1 = inner.faces().sort_by(Axis.Y).first
    opening_face2 = outer.faces().sort_by(Axis.Y).first
    loft([opening_face1, opening_face2], mode=Mode.SUBTRACT)

show(holder)

# %%
