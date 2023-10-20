from build123d import *
from ocp_vscode import *

import args
from joint import HalfJoint, JointHoles


def make_panel(
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
            with Locations((x, 0)):
                if y_joints[i] == Mode.SUBTRACT:
                    Rectangle(sheet_thicness, panel_size[1], mode=Mode.SUBTRACT)
                    continue
                if y_joints[i]:
                    JointHoles(y_joints[i], rotation=90)
        for i, y in enumerate(
            [
                -(panel_size[1] / 2 - sheet_thicness / 2),
                panel_size[1] / 2 - sheet_thicness / 2,
            ]
        ):
            with Locations((0, y)):
                if x_joints[i] == Mode.SUBTRACT:
                    Rectangle(panel_size[0], sheet_thicness, mode=Mode.SUBTRACT)
                    continue
                if x_joints[i]:
                    JointHoles(x_joints[i], rotation=0)
    return r.sketch

if __name__ == "__main__":
    from joint import DrawerJoint
    f1 = make_panel((300, 450), None, None)
    f2 = make_panel((300, 450), None, (None, Mode.SUBTRACT))
    f3 = make_panel((300, 450), None, (Mode.SUBTRACT, None))
    f4 = make_panel((300, 450), (Mode.SUBTRACT, None), None)
    f5 = make_panel((300, 450), (None, Mode.SUBTRACT), None)
    f6 = make_panel((300, 450), DrawerJoint(2, 300).b_half(), None)
    show_all()