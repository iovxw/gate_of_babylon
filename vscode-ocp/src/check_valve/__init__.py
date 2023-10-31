# %%
from build123d import *
from ocp_vscode import *

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

size = (130, 80, 130)
# %%
with BuildPart() as inner:
    with BuildSketch(Plane.YZ) as sk:
        with Locations((-size[1] / 2 +10, -size[2] / 2 + 1)):
            Polygon(
                (10, 0),
                (10, size[2] - 2),
                (size[1] - 1, size[2] - 2),
                (size[1] - 30, 0),
                align=(Align.MIN, Align.MIN),
            )
    extrude(amount=(size[0]-2)/2, both=True)
    f1 = inner.faces().sort_by(Axis.Y).first
    cut_plane = inner.faces().sort_by(Axis.Y).last
    Box(90,size[1],90)
    with BuildSketch(inner.faces().sort_by(Axis.Y).first) as f2:
        Rectangle(size[0]-10*2,size[2]-10*2)
    loft([f1,f2.sketch.face()])
show(inner)

# %%
with BuildPart() as r:
    Box(size[0],size[1],size[2])
    split(bisect_by=Plane(cut_plane).offset(1),keep=Keep.BOTTOM)
    add(inner.part, mode=Mode.SUBTRACT)
show(r)
r.part.export_step("/tmp/x.step")