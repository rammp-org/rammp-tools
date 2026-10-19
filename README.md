# rammp-tools

Container images for the generic tools a RAMMP deployment runs — things that
know nothing about any one robot, and get whatever is robot-specific from the
deployment. Sensor drivers live in `rammp-suite-software`; the robot's own
nodes live in their module repos.

| Tool | Image | Contents |
|---|---|---|
| Foxglove bridge (WebSocket on :8765) | `ghcr.io/rammp-org/rammp-tools/foxglove` | `ros-humble-foxglove-bridge` |
| Static TF (fixed and calibrated transforms on `/tf_static`) | `ghcr.io/rammp-org/rammp-tools/static_tf` | `docker/static_tf/static_tf.py` |

Each image is `rammp-base` plus one small thing: an `apt install` or a script.
The base is what puts a tool on Cyclone DDS with the fleet's config — the same
graph as the arm — and its tag is arm64-only, so these images are too.

## static_tf

Publishes every `*.yaml` in `/config/robot/transforms` once, latched, on
`/tf_static`. The deployment bind-mounts the robot's directory there; in
`rammp-deployments` that is `config/robots/<robot>/transforms/`.

Each file is in the format rammp-calibration's `solve_calibration.py` writes
(`mounts.yaml`), so a solved calibration drops in unchanged; hand-measured
transforms use the same format in a file of their own:

```yaml
mounts:
  ros__parameters:
    transforms: [scene_camera]     # every entry below, by name
    scene_camera:
      parent: arm_mount
      child: scene_camera
      xyz: [0.20, -0.50, 0.40]     # metres, child origin in parent
      quat_xyzw: [1.0, 0.0, 0.0, 0.0]
```

The node refuses to start, publishing nothing, if a child frame is named twice
(in one file or across files), a quaternion is not unit length, or an entry is
malformed. The same checks run without ROS, so a deployment's CI can gate its
files on a pinned release:

```bash
uv run https://raw.githubusercontent.com/rammp-org/rammp-tools/<tag>/docker/static_tf/static_tf.py \
  --validate config/robots/<robot>/transforms
```

```bash
make build              # every image, tagged :dev
make foxglove           # just one
make push TAG=v0.1.0    # after `docker login ghcr.io`
```

CI builds every image on every push and publishes branch, semver, and sha tags
to GHCR. The containers are *run* by sheppy, not by this repo: the flags they
need live with the deployment manifest in `rammp-deployments`.
