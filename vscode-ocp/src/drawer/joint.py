import args
from build123d import *
import copy
from typing import Self


class DrawerJoint:
    is_mortise: bool = False

    def __init__(
        self,
        tenon_num: int,
        panel_width: float,
        tenon_width: float = args.joint_a_width,
    ) -> None:
        self.tenon_num = tenon_num
        self.screw_num = tenon_num + 1
        self.panel_width = panel_width
        self.tenon_width = tenon_width
        self.tenon_spacing = (
            self.panel_width - self.tenon_width * self.tenon_num
        ) / self.screw_num
        self.screw_locs = [
            (self.tenon_width + self.tenon_spacing) * n
            + self.tenon_spacing / 2
            - self.panel_width / 2
            for n in range(0, self.screw_num)
        ]
        self.tenon_locs = [
            p + self.tenon_spacing / 2 + self.tenon_width / 2 for p in self.screw_locs
        ][slice(self.tenon_num)]

    def tenon(self) -> Self:
        r = copy.deepcopy(self)
        r.is_mortise = False
        return r

    def mortise(self) -> Self:
        r = copy.deepcopy(self)
        r.is_mortise = True
        return r


class JointHoles(BaseSketchObject):
    def __init__(
        self,
        joint: DrawerJoint,
        rotation: float = 0,
        align: tuple[Align, Align] = (Align.CENTER, Align.CENTER),
        mode: Mode = Mode.SUBTRACT,
    ):
        with BuildSketch() as r:
            if joint.is_mortise:
                with Locations(*[(x, 0) for x in joint.tenon_locs]):
                    Rectangle(joint.tenon_width, args.sheet_thickness)
                with Locations(*[(x, 0) for x in joint.screw_locs]):
                    Circle(args.screw_hole_r)
            else:
                Rectangle(joint.panel_width * 3, args.sheet_thickness)
                with Locations(*[(x, 0) for x in joint.tenon_locs]):
                    Rectangle(
                        joint.tenon_width, args.sheet_thickness, mode=Mode.SUBTRACT
                    )
        super().__init__(obj=r.sketch, rotation=rotation, align=align, mode=mode)
