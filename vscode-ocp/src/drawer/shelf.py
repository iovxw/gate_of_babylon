# %%
from build123d import *
from ocp_vscode import *

import args

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
layerboard_size = (
    args.drawer_shelf_size[0],
    args.drawer_shelf_size[1] - args.sheet_thickness*2,
)
layerboard_y_joint_a_num = 3
layerboard_y_joint_b_num = layerboard_y_joint_a_num + 1
layerboard_y_joint_b_width = (
    layerboard_size[1] - args.joint_a_width * layerboard_y_joint_a_num
) / layerboard_y_joint_b_num
layerboard_y_joint_a_locs = [
    (layerboard_y_joint_b_width + args.joint_a_width) * n
    - args.joint_a_width / 2
    - layerboard_size[1] / 2
    for n in range(1, layerboard_y_joint_b_num)
]
layerboard_y_joint_b_locs = [
    (layerboard_y_joint_b_width + args.joint_a_width) * n
    + layerboard_y_joint_b_width / 2
    - layerboard_size[1] / 2
    for n in range(0, layerboard_y_joint_b_num)
]
layerboard_y_joint_a_locs = [
    y + (layerboard_y_joint_b_width + args.joint_a_width) / 2
    for y in layerboard_y_joint_b_locs
]

# %%
with BuildSketch() as layerboard:
    Rectangle(args.drawer_shelf_size[0], layerboard_size[1])
    with Locations(
        *[
            (x, y)
            for y in layerboard_y_joint_b_locs
            for x in [
                -(args.drawer_shelf_size[0] / 2 - args.sheet_thickness / 2),
                args.drawer_shelf_size[0] / 2 - args.sheet_thickness / 2,
            ]
        ]
    ) as loc:
        Rectangle(args.sheet_thickness, layerboard_y_joint_b_width, mode=Mode.SUBTRACT)
    with Locations((0, 50)):
        drawerx1_bottom_x_sacing = (
            args.drawer_shelf_size[0]
        ) / 2 + args.drill_bit_size * 3 / 2
        Rectangle(
            drawerx1_bottom_x_sacing,
            layerboard_size[1],
            mode=Mode.SUBTRACT,
        )
with BuildSketch() as r:
    with Locations(
        (0, 0),
        Location(
            (
                drawerx1_bottom_x_sacing - args.drill_bit_size,
                50 + args.drill_bit_size,
                0,
            ),
            (0, 0, 180),
        ),
        Location(
            (
                -(drawerx1_bottom_x_sacing - args.drill_bit_size),
                50 + args.drill_bit_size,
                0,
            ),
            (0, 0, 180),
        ),
    ):
        add(layerboard.sketch)
show(r)
exporter = ExportDXF()
exporter.add_layer(
    "Layer 1",
)
exporter.add_shape(r.sketch, layer="Layer 1")
exporter.write("/tmp/output.dxf")

# %%
