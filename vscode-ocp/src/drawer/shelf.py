# %%
import math
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
layerboard_void_x = shelf_size[0] / 2 + args.drill_bit_size * 3 / 2

with BuildSketch() as layerboard:
    add(make_panel(shelf_size, Mode.SUBTRACT, layerboard_y_joint.tenon()))
    with Locations((0, 50)):
        Rectangle(
            layerboard_void_x,
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
back2side_joint_num = math.ceil(shelf_height / 3 / args.tenon_width)
back2side_joint = DrawerJoint(
    back2side_joint_num, shelf_height - args.sheet_thickness * 2
)
back2top_joint = DrawerJoint(2, shelf_size[0] - args.sheet_thickness * 2)

with BuildSketch(Plane.XZ) as side_panel:
    add(
        make_panel(
            (shelf_size[1], shelf_height),
            (None, side2top_joint.tenon()),
            (Mode.SUBTRACT, back2side_joint.mortise()),
        )
    )
    for i, y in enumerate(shelf_layerboard_pos):
        with Locations((0, y)):
            JointHoles(layerboard_y_joint.mortise())
show(side_panel)

# %%
with BuildSketch() as top_panel:
    add(
        make_panel(
            shelf_size, (None, back2top_joint.mortise()), side2top_joint.mortise()
        )
    )
show(top_panel)

# %%
layerboard_back_screw_x = (
    (shelf_size[0] - args.sheet_thickness * 2 + layerboard_void_x) / 2 / 2
)
back2layerboard_screw_pos = [
    (x, y)
    for x in [
        -layerboard_back_screw_x,
        layerboard_back_screw_x,
    ]
    for y in shelf_layerboard_pos
]
back_hole_x = shelf_size[0] / 5
back_holes_pos = [
    (x, y+args.sheet_thickness+height/2)
    for x in [
        -back_hole_x,
        back_hole_x,
    ]
    for y, height in zip(shelf_layerboard_pos,args.box_height_list[::-1])
]

with BuildSketch() as back_panel:
    add(
        make_panel(
            (shelf_size[0], shelf_height),
            (None, back2top_joint.tenon()),
            back2side_joint.tenon(),
        )
    )
    with Locations(*back2layerboard_screw_pos) as pos:
        Circle(args.screw_hole_r, mode=Mode.SUBTRACT)
    with Locations(*back_holes_pos) as pos:
        SlotOverall(35,15,mode=Mode.SUBTRACT)
show(back_panel)

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
    RigidJoint(
        "top_back",
        joint_location=Location(
            (0, shelf_size[1] / 2, args.sheet_thickness), (0, 0, 0)
        ),
    )

show(top_panel_builder.part, render_joints=True)

# %%
with BuildPart() as back_panel_builder:
    extrude(back_panel.sketch, args.sheet_thickness)
    RigidJoint(
        "top_back",
        joint_location=Location((0, shelf_height / 2, 0), (-90, 0, 0)),
    )
show(back_panel_builder.part, render_joints=True)
# %%
boxes = [
    (
        DrawerBox((args.box_size_inner[0], args.box_size_inner[1], h)),
        copy.copy(layerboard_builder.part),
    )
    for h in args.box_height_list
]
for i, (box, layerboard_part) in enumerate(boxes):
    layerboard_part.label = f"layerboard{i}"
    box.part.label = f"box{i}"
    side_panel_left_builder.part.joints[f"layerboard{i}"].connect_to(
        layerboard_part.joints["left_side"]
    )
    layerboard_part.joints["right_side"].connect_to(
        side_panel_right_builder.part.joints[f"layerboard{i}"]
    )
    layerboard_part.joints["box"].connect_to(box.part.joints["layerboard"])

side_panel_left_builder.part.joints["top_left"].connect_to(
    top_panel_builder.part.joints["top_left"]
)
top_panel_builder.part.joints["top_back"].connect_to(
    back_panel_builder.part.joints["top_back"]
)

comp = Compound(
    children=[
        side_panel_left_builder.part,
        side_panel_right_builder.part,
        top_panel_builder.part,
        back_panel_builder.part,
    ]
    + [box.part for box, _ in boxes]
    + [l for _, l in boxes]
)
show(comp, render_joints=True)

# %%
