import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import griddata

try:
    df = pd.read_csv('input.csv')
except FileNotFoundError:
    print("Error: 'input.csv' not found. Please check the file path.")
    exit()

if len(df.columns) < 4:
    print(f"Error: The input file must have at least 4 columns. Found {len(df.columns)}.")
    exit()

x_data = df.iloc[:, 0]
y_data = df.iloc[:, 1]
z_data = df.iloc[:, 2]
## implement color maping based on the fourth col
w_data = df.iloc[:, 3]

fig = plt.figure(figsize=(15, 12))
ax = fig.add_subplot(111, projection='3d')

xi = np.linspace(x_data.min(), x_data.max(), 50)
yi = np.linspace(y_data.min(), y_data.max(), 50)
xi_mg, yi_mg = np.meshgrid(xi, yi)

## cubic is close enough 
z_surf = griddata((x_data, y_data), z_data, (xi_mg, yi_mg), method='cubic')
w_surf = griddata((x_data, y_data), w_data, (xi_mg, yi_mg), method='cubic')

norm = plt.Normalize(vmin=w_data.min(), vmax=w_data.max())
colors = plt.cm.plasma(norm(w_surf))

surf = ax.plot_surface(xi_mg, yi_mg, z_surf, facecolors=colors, alpha=0.9, shade=True)

ax.scatter(x_data, y_data, z_data, c=w_data, cmap='plasma', s=20, alpha=0.3)

def zoom_factory(ax, base_scale=1.1):
    def zoom(event):
        if event.inaxes != ax:
            return

        if event.button == 'up':
            ## Zoom in
            scale_factor = 1 / base_scale
        elif event.button == 'down':
            ## Zoom out
            scale_factor = base_scale
        else:
            # idk
            return

        def scale_limits(lims, scale, center=None):
            lo, hi = lims
            if center is None:
                center = (lo + hi) / 2.0
            lo_dist = (lo - center) * scale
            hi_dist = (hi - center) * scale
            return center + lo_dist, center + hi_dist

        # limits
        xlim = ax.get_xlim3d()
        ylim = ax.get_ylim3d()
        zlim = ax.get_zlim3d()

        x_center = (xlim[0] + xlim[1]) / 2.0
        y_center = (ylim[0] + ylim[1]) / 2.0
        z_center = (zlim[0] + zlim[1]) / 2.0

        # scaling
        new_xlim = scale_limits(xlim, scale_factor, x_center)
        new_ylim = scale_limits(ylim, scale_factor, y_center)
        new_zlim = scale_limits(zlim, scale_factor, z_center)

        ax.set_xlim3d(new_xlim)
        ax.set_ylim3d(new_ylim)
        ax.set_zlim3d(new_zlim)

        ax.figure.canvas.draw_idle()

    return zoom

zoom_handler = zoom_factory(ax, base_scale=1.2)
fig.canvas.mpl_connect('scroll_event', zoom_handler)

ax.set_xlabel(df.columns[0], labelpad=15)
ax.set_ylabel(df.columns[1], labelpad=15)
ax.set_zlabel(df.columns[2], labelpad=15)

cbar = fig.colorbar(surf, ax=ax, pad=0.1, aspect=30)
cbar.set_label(f'{df.columns[3]} (Color Scale)', fontsize=10, labelpad=10)

ax.set_title(f'Surface Plot: {df.columns[2]} vs {df.columns[0]}, {df.columns[1]}\nColor represents {df.columns[3]}', pad=20, fontsize=12)

fig.text(0.02, 0.02, 'Use mouse wheel to zoom\nClick and drag to rotate view', fontsize=9, bbox=dict(facecolor='white', alpha=0.7))

ax.view_init(elev=30, azim=45)

ax.tick_params(labelsize=9, pad=8)

plt.show()