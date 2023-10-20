from build123d import *
from ocp_vscode import *
import copy

import args
from joint import DrawerJoint
from panel import make_panel
set_defaults(reset_camera=Camera.KEEP, helper_scale=5)


class DrawerBox:
    def __init__(
        self,
        inner_size: tuple[float, float, float],
        sheet_thickness: float = args.sheet_thickness,
    ) -> None:
        outer_size = (
            inner_size[0] + sheet_thickness * 2,
            inner_size[1] + sheet_thickness * 2,
            inner_size[2] + sheet_thickness,
        )
        self.bottom_y_joint = DrawerJoint(3, inner_size[1])
        self.bottom_x_joint = DrawerJoint(2, outer_size[0])

        self.bottom_sketch = make_panel(
            (outer_size[0], outer_size[1]),
            self.bottom_x_joint.a_half(),
            self.bottom_y_joint.a_half(),
        )
        self.front_back_joint = DrawerJoint(1, outer_size[2])
        self.side_sketch = make_panel(
            (outer_size[2], outer_size[1]),
            self.front_back_joint.a_half(),
            (self.bottom_y_joint.b_half(), None),
        )
        self.back_sketch = make_panel(
            (outer_size[0], outer_size[2]),
            (self.bottom_x_joint.b_half(), None),
            self.front_back_joint.b_half(),
        )
        with BuildSketch() as front:
            Rectangle(
                outer_size[0] + sheet_thickness * 2,
                outer_size[2] + sheet_thickness,
                align=(Align.CENTER, Align.MAX),
            )
            Rectangle(
                outer_size[0],
                outer_size[2],
                align=(Align.CENTER, Align.MAX),
                mode=Mode.SUBTRACT,
            )
            add(self.back_sketch.moved(Location((0, -outer_size[2] / 2))))
        self.front_sketch = front.sketch

        with BuildPart() as box_bottom:
            extrude(self.bottom_sketch, sheet_thickness)
            RigidJoint(
                "front",
                joint_location=Location((0, -(outer_size[1] / 2), 0)),
            )
            RigidJoint(
                "back",
                joint_location=Location((0, (outer_size[1] / 2), 0), 180),
            )
            RigidJoint(
                "left",
                joint_location=Location((-(outer_size[0] / 2), 0, 0), (0, 0, -90)),
            )
            RigidJoint(
                "right",
                joint_location=Location(((outer_size[0] / 2), 0, 0), (0, 0, 90)),
            )

        with BuildPart() as box_front:
            extrude(self.front_sketch, sheet_thickness)
            RigidJoint(
                "bottom",
                joint_location=Location((0, -outer_size[2], 0), (90, 180, 0)),
            )
        box_bottom.joints["front"].connect_to(box_front.joints["bottom"])

        with BuildPart() as box_back:
            extrude(self.back_sketch, sheet_thickness)
            RigidJoint(
                "bottom",
                joint_location=Location((0, -outer_size[2] / 2, 0), (90, 180, 0)),
            )
        box_bottom.joints["back"].connect_to(box_back.joints["bottom"])

        with BuildPart() as box_left:
            extrude(self.side_sketch, sheet_thickness)
            RigidJoint(
                "bottom",
                joint_location=Location((-outer_size[2] / 2, 0), (0, 90, 90)),
            )
        box_bottom.joints["left"].connect_to(box_left.joints["bottom"])
        box_right = copy.copy(box_left.part)
        box_bottom.joints["right"].connect_to(box_right.joints["bottom"])

        self.part = Compound(
            children=[
                box_bottom.part,
                box_front.part,
                box_back.part,
                box_left.part,
                box_right,
            ]
        )
        RigidJoint(
            "layerboard",
            to_part=self.part,
            joint_location=Location((0, -inner_size[1] / 2, 0)),
        )


if __name__ == "__main__":
    b = DrawerBox(
        (args.box_size_inner[0], args.box_size_inner[1], args.box_height_list[0])
    )
    show(b.part, b.part.joints["layerboard"].symbol, render_joints=True)
