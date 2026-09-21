# rammp-tools

Container images for the tools that run beside a RAMMP deployment — things
you point at the robot, not parts of it. Sensor drivers live in
`rammp-suite-software`; the robot's own nodes live in their module repos.

| Tool | Image | ROS package |
|---|---|---|
| Foxglove bridge (WebSocket on :8765) | `ghcr.io/rammp-org/rammp-tools/foxglove` | `ros-humble-foxglove-bridge` |

Each image is `rammp-base` plus one `apt install`. The base is what puts a
tool on Cyclone DDS with the fleet's config — the same graph as the arm — and
its tag is arm64-only, so these images are too.

```bash
make build              # every image, tagged :dev
make foxglove           # just one
make push TAG=v0.1.0    # after `docker login ghcr.io`
```

CI builds every image on every push and publishes branch, semver, and sha tags
to GHCR. The containers are *run* by sheppy, not by this repo: the flags they
need live with the deployment manifest in `rammp-deployments`.
