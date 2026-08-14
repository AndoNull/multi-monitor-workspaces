# Multi-Monitor Workspaces

An Omarchy bar widget that assigns workspace indicators to displays:

- **HDMI-A-1:** workspaces 1–5
- **eDP-1:** workspaces 6–10
- **No HDMI-A-1:** the laptop display shows workspaces 1–5, matching the stock widget.

The widget shows an occupied or focused state and lets you focus a workspace by clicking its indicator.

## Requirements

- Omarchy with the Quattro shell
- Hyprland
- A display configuration whose connector names are `HDMI-A-1` and `eDP-1`

If your connectors use different names, update `hdmiConnected()` and `workspaceIds()` in `Workspaces.qml` before installing.

## Install

Install and enable using Omarchy's plugin command:

```sh
omarchy plugin add https://github.com/DillanMateusHkl/multi-monitor-workspaces.git --enable
```

After installation, enable Multi-Monitor Workspaces in the bar widget settings if it is not already visible.


## Validate

```sh
omarchy plugin validate .
qmllint -I "$OMARCHY_PATH/shell" Workspaces.qml
```

## Behavior

With an external display connected, all displays other than `eDP-1` use workspaces 1–5. The built-in `eDP-1` display uses workspaces 6–10. When `HDMI-A-1` is not connected, all displays use workspaces 1–5.

## License

[MIT](LICENSE)
