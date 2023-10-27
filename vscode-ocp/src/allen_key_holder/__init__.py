# %%
from build123d import *
from ocp_vscode import *
set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
b = Box(1,2,3)
show(b)

# %%
sizes = [10, 8, 6, 5, 4, 3.5, 3, 2.5, 2, 1.5]
thickness = 2
with BuildPart() as holder:
    x = 0
    for d in sizes:
        with BuildSketch() as sk:
            with Locations((x, 0)):
                #Circle(d / 2 + 1.5, align=(Align.CENTER, Align.MIN))
                Rectangle(d+thickness*2,d+thickness*2, align=(Align.MIN, Align.MIN))
                with Locations((thickness, thickness)) as locs:
                    #Circle(d/2, align=(Align.CENTER,Align.MIN), mode=Mode.SUBTRACT)
                    Rectangle(d, d+thickness, align=(Align.MIN,Align.MIN), mode=Mode.SUBTRACT)
                
        x += d+thickness*2
    extrude(amount=20)
    extrude(holder.faces().sort_by(Axis.X).first,amount=thickness)
    extrude(holder.faces().sort_by(Axis.Y).first,amount=thickness)

show(holder)
holder.part.export_step("/tmp/holder.step")
# %%
