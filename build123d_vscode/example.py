from build123d import *
from ocp_vscode import show_object, reset_show, set_defaults

reset_show() # use for reapeated shift-enter execution to clean object buffer
set_defaults(
    control="orbit",
    axes=True,
    axes0=True,
    grid=(True, False, False),
    glass=True,
    theme="browser",
)

with BuildPart() as sphere:
    Sphere(0.6)

show_object(
    sphere.part,
)