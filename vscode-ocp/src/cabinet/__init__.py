# %%
from build123d import *
from ocp_vscode import *
import copy
import math

import shelf
import args
from typing import Self

set_defaults(reset_camera=Camera.KEEP, helper_scale=5)

# %%
# 把手用布条

show(shelf.comp, render_joints=True)


# %%
class StaticSketch:
    sketch: Sketch
    bsize: Vector
    def __init__(self, sketch:Sketch) -> None:
        self.sketch: Sketch = Plane(sketch.face()).to_local_coords(sketch)
        bbox = self.sketch.bounding_box()
        self.bsize = self.sketch.bounding_box().size
        self.sketch.move(Location((-bbox.min.X, -bbox.min.Y, 0)))
    def rotate(self) -> Self:
        self.sketch.move(Location((0, 0, 0), (0, 0, 90)))
        bbox = self.sketch.bounding_box()
        self.bsize = self.sketch.bounding_box().size
        self.sketch.move(Location((-bbox.min.X, -bbox.min.Y, 0)))
        return self
    def place_sketch(self, loc: Location) -> Sketch:
        return self.sketch.moved(loc)


def find_sketch(sketches: list[StaticSketch], size: tuple[float, float]) -> StaticSketch | None:
    for i in range(0, len(sketches)):
        s = sketches[i]
        if s.bsize.X <= size[0] and s.bsize.Y <= size[1]:
            return sketches.pop(i)
        if s.bsize.X <= size[1] and s.bsize.Y <= size[0]:
            return sketches.pop(i).rotate()
    if min(*size) > 50:
        return StaticSketch(Rectangle(*size, align=(Align.MIN, Align.MIN)))


def arrange(
    sketchs: list[Sketch],
    sheet_size: tuple[float, float] = (2440,1220),
    spacing: float = args.drill_bit_size,
) -> list[Sketch]:
    sketchs:list[StaticSketch] = [StaticSketch(s) for s in sketchs]
    size = 0
    for s in sketchs:
        size += s.bsize.X * s.bsize.Y
    print(f"sketchs size:{size}, sheet size: {math.prod(sheet_size)}")
    if size > math.prod(sheet_size):
        raise Exception("sketchs too large")
    for s in sketchs:
        if s.bsize.Y > s.bsize.X:
            s.rotate()
    sketchs.sort(key=lambda s: (s.bsize.Y, s.bsize.X))
    sketchs.reverse()
    x, y = 0, 0
    current_row_y_max = 0
    r = []
    while len(sketchs) > 0:
        s = sketchs.pop(0)
        if x + s.bsize.X > sheet_size[0]:
            s2 = find_sketch(sketchs, (sheet_size[0] - x, current_row_y_max))
            if s2:
                sketchs.insert(0, s)
                sketchs.insert(0, s2)
            else:
                x = 0
                y += current_row_y_max + spacing
                current_row_y_max = 0
                sketchs.insert(0, s)
            continue
        if s.bsize.Y >= current_row_y_max:
            current_row_y_max = s.bsize.Y
        else:
            if s.bsize.X < current_row_y_max+20:
                s.rotate()
                if s.bsize.Y >= current_row_y_max:
                    current_row_y_max = s.bsize.Y
            else:
                # try to fill the y gap
                y_gap = current_row_y_max - s.bsize.Y - spacing
                s2 = find_sketch(sketchs, (s.bsize.X, y_gap))
                if s2:
                    r.append(s2.place_sketch(Location((x, y + s.bsize.Y + spacing))))
        r.append(s.place_sketch(Location((x, y))))
        x += s.bsize.X + spacing
    return r


r = arrange(
    [
        shelf.side_panel.sketch,
        shelf.side_panel.sketch,
        shelf.top_panel.sketch,
        shelf.back_panel.sketch,
    ]
    +[copy.deepcopy(shelf.layerboard.sketch) for i in args.box_height_list]
)
show(r, Rectangle(2440,1220, align=(Align.MIN, Align.MIN)))

# %%
exporter = ExportDXF()
for i, face in enumerate(r):
    l = f"sketch{i}"
    exporter.add_layer(l)
    exporter.add_shape(face, layer=l)
exporter.write("/tmp/output.dxf")
