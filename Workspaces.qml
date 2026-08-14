import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// External displays show 1–5; the built-in display shows 6–10 whenever
// an external display is connected. A single-display setup shows 1–5.
BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  // Each widget is inside its own BarPanel. QsWindow is Omarchy's reliable
  // handle to that panel's QQuickWindow and therefore its specific screen.
  readonly property var barWindow: root.QsWindow ? root.QsWindow.window : null
  readonly property string screenName: barWindow && barWindow.screen
    ? String(barWindow.screen.name || "") : ""

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }
    return null
  }

  function isInternalDisplay(name) {
    // eDP, LVDS, and DSI are the standard connector families for laptop
    // panels. Match the family instead of relying on one machine's suffix.
    return /^(edp|lvds|dsi)/i.test(String(name || ""))
  }

  function hasExternalDisplay() {
    var monitors = Hyprland.monitors.values
    for (var i = 0; i < monitors.length; i++) {
      if (!isInternalDisplay(monitors[i].name)) return true
    }
    return false
  }

  function workspaceIds() {
    if (hasExternalDisplay() && isInternalDisplay(screenName)) return [6, 7, 8, 9, 10]
    return [1, 2, 3, 4, 5]
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)
  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData
        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : String(modelData)
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
