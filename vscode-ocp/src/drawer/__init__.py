# %%
from build123d import *
from ocp_vscode import *
import copy
import math

import shelf
import args

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
# 把手用布条

show(shelf.comp, render_joints=True)

# %%
with BuildSketch() as layerboards:
    board = shelf.layerboard.sketch
    board_bbox = board.bounding_box()
    board = board.moved(Location((-board_bbox.min.X, -board_bbox.min.Y, 0)))
    with Locations(
        *[
            ((board_bbox.size.X + args.drill_bit_size) * i, 0)
            for i in range(0, math.floor(len(shelf.boxes) / 2))
        ]
    ):
        add(board)
    with Locations(
        *[
            (
                (board_bbox.size.X + args.drill_bit_size) * i
                + board_bbox.size.X / 2
                - args.drill_bit_size / 2,
                board_bbox.size.Y + 50 - args.drill_bit_size / 2,
            )
            for i in range(0, math.ceil(len(shelf.boxes) / 2))
        ]
    ):
        add(board, rotation=180)
show(layerboards)


# %%
def find_sketch(sketches: list[Sketch], size: tuple[float, float]) -> Sketch | None:
    for i in range(0, len(sketches)):
        s = sketches[i]
        bsize = s.bounding_box().size
        if bsize.X <= size[0] and bsize.Y <= size[1]:
            return sketches.pop(i)
        if bsize.X <= size[1] and bsize.Y <= size[0]:
            s = sketches.pop(i).rotate(Axis.Z, 90)


def arrange(
    sketchs: list[Sketch],
    sheet_size: tuple[float, float] = (1200, 2440),
    spacing: float = args.drill_bit_size,
) -> Sketch:
    sketchs = [Plane(s.face()).to_local_coords(s) for s in sketchs]
    for s in sketchs:
        bbox = s.bounding_box()
        s.move(Location((-bbox.min.X, -bbox.min.Y)))
    sketchs.sort(key=lambda s: (s.bounding_box().size.Y, s.bounding_box().size.X))
    x, y = 0, 0
    current_row_y_max = 0
    with BuildSketch() as r:
        while len(sketchs) > 0:
            s = sketchs.pop(0)
            bbox = s.bounding_box()
            if x + bbox.size.X > sheet_size[0]:
                s2 = find_sketch(sketchs, (sheet_size[0] - x, current_row_y_max))
                if s2:
                    sketchs.insert(0, s)
                    sketchs.insert(0, s2)
                else:
                    x = 0
                    y += current_row_y_max + spacing
                    sketchs.insert(0, s)
                continue
            if bbox.size.Y > current_row_y_max:
                current_row_y_max = bbox.size.Y
            loc = Location((x, y))
            s.move(Location((x, y)))
            x += bbox.size.X + spacing
            add(s)
    return r.sketch


boxes = [box for box, _ in shelf.boxes]
fronts = [box.front_sketch for box in boxes]
backs = [box.back_sketch for box in boxes]
sides = [box.side_sketch for box in boxes] * 2
r = arrange(
    [
        shelf.side_panel.sketch,
        shelf.side_panel.sketch,
        shelf.top_panel.sketch,
        layerboards.sketch,
    ]
    + fronts
    + backs
    + sides
)
show(r, Rectangle(1200, 2440, align=(Align.MIN, Align.MIN)))

# %%
exporter = ExportDXF()
exporter.add_layer(
    "Layer 1",
)
exporter.add_shape(r.sketch, layer="Layer 1")
exporter.write("/tmp/output.dxf")
