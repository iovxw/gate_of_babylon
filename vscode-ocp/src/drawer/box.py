# %%
from build123d import *
from ocp_vscode import *
import copy

import args
from joint import DrawerJoint, HalfJoint

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
def make_box_panel(
    panel_size: tuple[float, float],
    x_joints: HalfJoint | tuple[HalfJoint, HalfJoint],
    y_joints: HalfJoint | tuple[HalfJoint, HalfJoint],
    sheet_thicness: float = args.sheet_thickness,
) -> Sketch:
    if x_joints.__class__ is not tuple:
        x_joints = (x_joints, x_joints)
    if y_joints.__class__ is not tuple:
        y_joints = (y_joints, y_joints)
    with BuildSketch() as r:
        Rectangle(panel_size[0], panel_size[1])
        for i, x in enumerate(
            [
                -(panel_size[0] / 2 - sheet_thicness / 2),
                panel_size[0] / 2 - sheet_thicness / 2,
            ]
        ):
            if y_joints[i]:
                with Locations(*[(x, y) for y in y_joints[i].other_locs]):
                    Rectangle(
                        sheet_thicness, y_joints[i].other_width, mode=Mode.SUBTRACT
                    )
                if y_joints[i].is_b:
                    with Locations(*[(x, y) for y in y_joints[i].locs]):
                        Circle(args.screw_hole_r, mode=Mode.SUBTRACT)
        for i, y in enumerate(
            [
                -(panel_size[1] / 2 - sheet_thicness / 2),
                panel_size[1] / 2 - sheet_thicness / 2,
            ]
        ):
            if x_joints[i]:
                with Locations(*[(x, y) for x in x_joints[i].other_locs]) as loc:
                    Rectangle(
                        x_joints[i].other_width, sheet_thicness, mode=Mode.SUBTRACT
                    )
                if x_joints[i].is_b:
                    with Locations(*[(x, y) for x in x_joints[i].locs]):
                        Circle(args.screw_hole_r, mode=Mode.SUBTRACT)
    return r.sketch


# %%
bottom_y_joint = DrawerJoint(
    3, args.drawer_box_size_outer[1] - args.sheet_thickness * 2
)
bottom_x_joint = DrawerJoint(2, args.drawer_box_size_outer[0])

drawerx1_bottom = make_box_panel(
    (args.drawer_box_size_outer[0], args.drawer_box_size_outer[1]),
    bottom_x_joint.a_half(),
    bottom_y_joint.a_half(),
)
show(drawerx1_bottom)

# %%
drawerx1_front_back_joint = DrawerJoint(1, args.drawer_box_size_outer[2])
drawerx1_side = make_box_panel(
    (args.drawer_box_size_outer[2], args.drawer_box_size_outer[1]),
    drawerx1_front_back_joint.a_half(),
    (bottom_y_joint.b_half(), None),
)
show(drawerx1_side)

# %%
drawerx1_back = make_box_panel(
    (args.drawer_box_size_outer[0], args.drawer_box_size_outer[2]),
    (bottom_x_joint.b_half(), None),
    drawerx1_front_back_joint.b_half(),
)
show(drawerx1_back)

# %%
with BuildSketch() as drawerx1_front:
    Rectangle(
        args.drawer_box_size_outer[0] + args.sheet_thickness * 2,
        args.drawer_box_size_outer[2]
        + args.sheet_thickness
        - args.box2shelf_spacing * 2,
        align=(Align.CENTER, Align.MAX),
    )
    Rectangle(
        args.drawer_box_size_outer[0],
        args.drawer_box_size_outer[2],
        align=(Align.CENTER, Align.MAX),
        mode=Mode.SUBTRACT,
    )
    add(drawerx1_back.moved(Location((0, -args.drawer_box_size_outer[2] / 2))))

show(drawerx1_front)

# %%
with BuildPart() as box1_bottom:
    extrude(drawerx1_bottom, args.sheet_thickness)
    RigidJoint(
        "front",
        joint_location=Location((0, -(args.drawer_box_size_outer[1] / 2), 0)),
    )
    RigidJoint(
        "back",
        joint_location=Location((0, (args.drawer_box_size_outer[1] / 2), 0), 180),
    )
    RigidJoint(
        "left",
        joint_location=Location(
            (-(args.drawer_box_size_outer[0] / 2), 0, 0), (0, 0, -90)
        ),
    )
    RigidJoint(
        "right",
        joint_location=Location(
            ((args.drawer_box_size_outer[0] / 2), 0, 0), (0, 0, 90)
        ),
    )

with BuildPart() as box1_front:
    extrude(drawerx1_front.sketch, args.sheet_thickness)
    RigidJoint(
        "bottom",
        joint_location=Location(
            (0, -args.drawer_box_size_outer[2], 0), (90, 180, 0)
        ),
    )
box1_bottom.joints["front"].connect_to(box1_front.joints["bottom"])

with BuildPart() as box1_back:
    extrude(drawerx1_back, args.sheet_thickness)
    RigidJoint(
        "bottom",
        joint_location=Location(
            (0, -args.drawer_box_size_outer[2]/2, 0), (90, 180, 0)
        ),
    )
box1_bottom.joints["back"].connect_to(box1_back.joints["bottom"])

with BuildPart() as box1_left:
    extrude(drawerx1_side, args.sheet_thickness)
    RigidJoint(
        "bottom",
        joint_location=Location(
            (-args.drawer_box_size_outer[2]/2, 0), (0, 90, 90)
        ),
    )
box1_bottom.joints["left"].connect_to(box1_left.joints["bottom"])
box1_right = copy.copy(box1_left.part)
box1_bottom.joints["right"].connect_to(box1_right.joints["bottom"])

box1 = Compound(children=[box1_bottom.part, box1_front.part, box1_back.part, box1_left.part, box1_right])
show(box1, render_joints=True)

# %%
