"""
Draw the geodesic associated with a hyperbolic matrix in SL(2, Z)
alongside the standard fundamental domain of SL(2, Z) in the upper
half-plane.

Running this script produces a PDF named
``img_{matrix_entries}_{random_hash}.pdf`` in the current directory.
"""

import uuid
from dataclasses import dataclass
from typing import Tuple

import numpy as np

# Use a non-interactive backend to allow running in headless environments.
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


@dataclass
class SL2ZMatrix:
    a: int
    b: int
    c: int
    d: int

    def fixed_points(self) -> Tuple[float, float]:
        """Return the real fixed points of the matrix on the boundary of H."""
        # Solve c z^2 + (d - a) z - b = 0
        if self.c == 0:
            # One fixed point at infinity and one finite fixed point
            if self.d == self.a:
                raise ValueError("Matrix is not hyperbolic: repeated root with c=0.")
            root = self.b / (self.d - self.a)
            return float("inf"), float(root)

        coeffs = [self.c, self.d - self.a, -self.b]
        roots = np.roots(coeffs)
        roots = np.real_if_close(roots)
        if not np.isrealobj(roots):
            raise ValueError("Hyperbolic matrix should have real fixed points.")
        roots = np.real(roots)
        return float(np.min(roots)), float(np.max(roots))

    def label(self) -> str:
        return f"{self.a}_{self.b}_{self.c}_{self.d}"


def geodesic_points(x1: float, x2: float, num: int = 300) -> Tuple[np.ndarray, np.ndarray]:
    """Return x and y coordinates for the geodesic between two boundary points."""
    if np.isinf(x1) or np.isinf(x2):
        finite = x1 if np.isfinite(x1) else x2
        y = np.linspace(0.1, 3.0, num)
        x = np.full_like(y, finite)
        return x, y

    center = 0.5 * (x1 + x2)
    radius = 0.5 * (x2 - x1)
    theta = np.linspace(0, np.pi, num)
    x = center + radius * np.cos(theta)
    y = np.abs(radius) * np.sin(theta)
    return x, y


def fundamental_domain(ax: plt.Axes, ymax: float = 3.0) -> None:
    """Draw the necessary boundary of the standard fundamental domain."""
    x_arc = np.linspace(np.pi / 3, 2 * np.pi / 3, 200)
    arc_x = np.cos(x_arc)
    arc_y = np.sin(x_arc)

    y_top = ymax
    y_bottom = np.sqrt(3) / 2
    left_x = -0.5 * np.ones_like(np.linspace(y_bottom, y_top, 2))
    right_x = 0.5 * np.ones_like(np.linspace(y_bottom, y_top, 2))

    style = dict(color="grey", linewidth=2.0)
    ax.plot(arc_x, arc_y, **style)
    ax.plot(left_x, [y_bottom, y_top], **style)
    ax.plot(right_x, [y_bottom, y_top], **style)

    # Add light strokes to emphasise the boundary
    stroke_style = dict(color="lightgrey", linewidth=4.5, alpha=0.6, solid_capstyle="round")
    ax.plot(arc_x, arc_y, **stroke_style)
    ax.plot(left_x, [y_bottom, y_top], **stroke_style)
    ax.plot(right_x, [y_bottom, y_top], **stroke_style)


def plot_geodesic(matrix: SL2ZMatrix) -> str:
    x1, x2 = matrix.fixed_points()
    x_geo, y_geo = geodesic_points(x1, x2)

    fig, ax = plt.subplots(figsize=(6, 6))
    fundamental_domain(ax, ymax=max(3.0, y_geo.max()))

    ax.plot(x_geo, y_geo, color="steelblue", linewidth=2.5, label="Geodesic")

    ax.set_xlim(-2, 2)
    ax.set_ylim(0, max(3.0, y_geo.max() * 1.05))
    ax.set_aspect("equal")
    ax.axis("off")
    ax.legend(loc="upper right")

    filename = f"img_{matrix.label()}_{uuid.uuid4().hex[:8]}.pdf"
    fig.savefig(filename, bbox_inches="tight")
    plt.close(fig)
    return filename


def main() -> None:
    # Example matrix h = [[2, 1], [1, 1]]
    matrix = SL2ZMatrix(2, 1, 1, 1)
    output = plot_geodesic(matrix)
    print(f"Saved figure to {output}")


if __name__ == "__main__":
    main()
