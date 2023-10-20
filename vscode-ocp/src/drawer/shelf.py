# %%
from build123d import *
from ocp_vscode import *
import copy

import args
from panel import make_panel
from joint import DrawerJoint, JointHoles
from box import DrawerBox

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

box_size_outer = (
    args.box_size_inner[0] + args.sheet_thickness * 2,
    args.box_size_inner[1] + args.sheet_thickness * 2,
)
box_height_outer_list = [h + args.sheet_thickness for h in args.box_height_list]
shelf_size = (
    box_size_outer[0] + args.box2shelf_spacing * 2 + args.sheet_thickness * 2,
    box_size_outer[1] + args.box2shelf_spacing + args.sheet_thickness,
)
layerboard_y_joint = DrawerJoint(3, shelf_size[1] - args.sheet_thickness * 2)

with BuildSketch() as layerboard:
    add(make_panel(shelf_size, (Mode.SUBTRACT, None), layerboard_y_joint.a_half()))
    with Locations((0, 50)):
        drawerx1_bottom_x_sacing = shelf_size[0] / 2 + args.drill_bit_size * 3 / 2
        Rectangle(
            drawerx1_bottom_x_sacing,
            shelf_size[1] - args.sheet_thickness,
            mode=Mode.SUBTRACT,
        )
show(layerboard)
# %%
shelf_height_list = [
    h + args.sheet_thickness + args.box2shelf_spacing * 2 for h in box_height_outer_list
]
shelf_height_list.reverse()
shelf_height = sum(shelf_height_list) + args.sheet_thickness
shelf_layerboard_pos = [
    sum(shelf_height_list[slice(i)]) + args.sheet_thickness / 2
    for i in range(0, len(box_height_outer_list))
]
shelf_layerboard_pos = [pos - shelf_height / 2 for pos in shelf_layerboard_pos]
side2top_joint = DrawerJoint(3, shelf_size[1])

with BuildSketch(Plane.XZ) as side_panel:
    add(
        make_panel(
            (shelf_size[1], shelf_height),
            (None, side2top_joint.a_half()),
            (Mode.SUBTRACT, None),
        )
    )
    for i, y in enumerate(shelf_layerboard_pos):
        with Locations((0, y)):
            JointHoles(layerboard_y_joint.b_half())
show(side_panel)

# %%
with BuildSketch() as top_panel:
    add(make_panel(shelf_size, None, side2top_joint.b_half()))
show(top_panel)

# %%
with BuildPart() as layerboard_builder:
    extrude(layerboard.sketch, args.sheet_thickness)
    RigidJoint(
        "left_side",
        joint_location=Location((-shelf_size[0] / 2, 0), (0, 0, -90)),
    )
    RigidJoint(
        "right_side",
        joint_location=Location((shelf_size[0] / 2, 0), (0, 0, 90)),
    )
    RigidJoint(
        "box",
        joint_location=Location(
            (
                0,
                layerboard.sketch.bounding_box().min.Y,
                args.sheet_thickness + args.box2shelf_spacing,
            ),
            (0, 0, 0),
        ),
    )
show(layerboard_builder.part, render_joints=True)

# %%
with BuildPart() as side_panel_left_builder:
    extrude(side_panel.sketch, args.sheet_thickness)
    for i, z in enumerate(reversed(shelf_layerboard_pos)):
        RigidJoint(
            f"layerboard{i}",
            joint_location=Location((0, 0, z - args.sheet_thickness / 2), (0, 0, 180)),
        )
    RigidJoint(
        "top_left", joint_location=Location((0, 0, shelf_height / 2), (0, 0, -90))
    )
show(side_panel_left_builder.part, render_joints=True)
# %%
with BuildPart() as side_panel_right_builder:
    extrude(side_panel.sketch, -args.sheet_thickness)
    for i, z in enumerate(reversed(shelf_layerboard_pos)):
        RigidJoint(
            f"layerboard{i}",
            joint_location=Location((0, 0, z - args.sheet_thickness / 2), (0, 0, 0)),
        )
show(side_panel_right_builder.part, render_joints=True)

# %%
with BuildPart() as top_panel_builder:
    extrude(top_panel.sketch, args.sheet_thickness)
    RigidJoint(
        "top_left",
        joint_location=Location(
            (-shelf_size[0] / 2, 0, args.sheet_thickness), (0, 0, 0)
        ),
    )
    RigidJoint(
        "top_right",
        joint_location=Location(
            (shelf_size[0] / 2, 0, args.sheet_thickness), (0, 0, 180)
        ),
    )

show(top_panel_builder.part, render_joints=True)
# %%
boxes = [
    (
        DrawerBox((args.box_size_inner[0], args.box_size_inner[1], h)).part,
        copy.copy(layerboard_builder.part),
    )
    for h in args.box_height_list
]
for i, (box, layerboard_part) in enumerate(boxes):
    layerboard_part.label = f"layerboard{i}"
    box.label = f"box{i}"
    side_panel_left_builder.part.joints[f"layerboard{i}"].connect_to(
        layerboard_part.joints["left_side"]
    )
    layerboard_part.joints["right_side"].connect_to(
        side_panel_right_builder.part.joints[f"layerboard{i}"]
    )
    layerboard_part.joints["box"].connect_to(box.joints["layerboard"])

side_panel_left_builder.part.joints["top_left"].connect_to(
    top_panel_builder.part.joints["top_left"]
)

comp = Compound(
    children=[
        side_panel_left_builder.part,
        side_panel_right_builder.part,
        top_panel_builder.part,
    ]
    + [box for box, _ in boxes]
    + [l for _, l in boxes]
)
show(comp, render_joints=True)
# %%
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
        add(layerboard.sketch.moved(Location((0, -args.sheet_thickness / 4, 0))))
show(r)
exporter = ExportDXF()
exporter.add_layer(
    "Layer 1",
)
exporter.add_shape(r.sketch, layer="Layer 1")
exporter.write("/tmp/output.dxf")

# %%
