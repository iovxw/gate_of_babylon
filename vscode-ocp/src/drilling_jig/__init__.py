# %%
from build123d import *
from ocp_vscode import *

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
thickness = 6
batten_size = (25, 36)
joint_d = 5+0.2
joint_spacing = 15

holes = [
    loc * Hole(joint_d / 2, 999)
    for loc in Locations((0, -joint_spacing / 2), (0, joint_spacing / 2))
]

jig_a = (
    Box(
        batten_size[0] + thickness * 2,
        batten_size[1] - 5,
        thickness + 10,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    + Box(
        batten_size[0] - 5,
        batten_size[1] + thickness * 2,
        thickness + 10,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    - Box(
        batten_size[0],
        batten_size[1],
        10,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    - holes
)
show(jig_a)
jig_a.export_step("/tmp/jig_a.step")
# %%
jig_b = (
    Box(batten_size[0], batten_size[1], thickness)
    + Box(batten_size[0] - 10, batten_size[1] * 2, thickness)
    + Box(batten_size[0] * 2, batten_size[1] - 10, thickness)
    - holes
)
show(jig_b)
jig_b.export_step("/tmp/jig_b.step")
# %%
jig_c = (
    Box(
        batten_size[0] + thickness * 2,
        batten_size[1],
        thickness,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    + Box(
        batten_size[0] - 10,
        batten_size[1] + 40,
        thickness,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    + Box(
        batten_size[0] + thickness * 2,
        batten_size[1],
        batten_size[1],
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - Box(
        batten_size[0],
        batten_size[1],
        batten_size[1],
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - holes
)
show(jig_c)
jig_c.export_step("/tmp/jig_c.step")
# %%
jig_c_two = [loc * jig_c for loc in Locations((0, 0), (batten_size[0] + thickness, 0))]
jig_c_two = sum(jig_c_two, Part())
show(jig_c_two)
jig_c_two.export_step("/tmp/jig_c_two.step")
# %%
jig_d = (
    Box(
        batten_size[0],
        batten_size[1] + thickness * 2,
        thickness,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    + Box(
        batten_size[0] + 40,
        20,
        thickness,
        align=(Align.CENTER, Align.CENTER, Align.MIN),
    )
    + Box(
        batten_size[0],
        batten_size[1]+ thickness * 2,
        batten_size[0],
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - Box(
        batten_size[0],
        batten_size[1],
        batten_size[0],
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - holes
)
show(jig_d)
jig_d.export_step("/tmp/jig_d.step")
# %%
jig_d_two = [loc * jig_d for loc in Locations((0, 0), (0, batten_size[1] + thickness))]
jig_d_two = sum(jig_d_two, Part())
show(jig_d_two)
jig_d_two.export_step("/tmp/jig_d_two.step")
# %%
saw_thickness = 1
saw_guide_thickness = 10
guide_length = 10
saw_guide = (
    Box(
        30,
        batten_size[1] + saw_guide_thickness * 2,
        batten_size[0] + guide_length * 2 + saw_guide_thickness,
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - Box(
        30,
        batten_size[1],
        batten_size[0] + guide_length,
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    + Location((30, 0, -(batten_size[0] + guide_length)))
    * Box(
        30,
        batten_size[1],
        guide_length + saw_guide_thickness,
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
    - Box(
        saw_thickness,
        batten_size[1] + saw_guide_thickness * 2,
        batten_size[0] + guide_length * 2,
        align=(Align.CENTER, Align.CENTER, Align.MAX),
    )
)
show(saw_guide)
saw_guide.export_step("/tmp/saw_guide.step")
# %%
