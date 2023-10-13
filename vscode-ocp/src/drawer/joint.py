import args


class HalfJoint:
    num: int = 0
    width: float = 0
    locs: list[float] = []
    other_num: int = 0
    other_width: float = 0
    other_locs: list[float] = []
    is_b: bool = False

    def __init__(
        self,
        num: int,
        width: float,
        locs: list[float],
        other_num: int,
        other_width: float,
        other_locs: list[float],
        is_b: bool,
    ) -> None:
        self.num = num
        self.width = width
        self.locs = locs
        self.other_num = other_num
        self.other_width = other_width
        self.other_locs = other_locs
        self.is_b = is_b


class DrawerJoint:
    def __init__(
        self, a_num: int, panel_width: float, joint_a_width: float = args.joint_a_width
    ) -> None:
        self.a_num = a_num
        self.b_num = a_num + 1
        self.panel_width = panel_width
        self.a_width = joint_a_width
        self.b_width = (panel_width - joint_a_width * a_num) / self.b_num
        self.b_locs = [
            (self.a_width + self.b_width) * n + self.b_width / 2 - self.panel_width / 2
            for n in range(0, self.b_num)
        ]
        self.a_locs = [p + self.b_width / 2 + self.a_width / 2 for p in self.b_locs][
            slice(self.a_num)
        ]

    def a_half(self) -> HalfJoint:
        return HalfJoint(
            self.a_num,
            self.a_width,
            self.a_locs,
            self.b_num,
            self.b_width,
            self.b_locs,
            False,
        )

    def b_half(self) -> HalfJoint:
        return HalfJoint(
            self.b_num,
            self.b_width,
            self.b_locs,
            self.a_num,
            self.a_width,
            self.a_locs,
            True,
        )
