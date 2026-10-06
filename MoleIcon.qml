import QtQuick
import QtQuick.Effects
import qs.Commons

// Mullvad mole in full colour. Same public surface as ThemeIcon so it can be
// swapped in wherever the connection state is shown:
//   connected    -> full colour
//   disconnected -> greyscale, dimmed
//   connecting   -> greyscale, pulsing
//   warning/err  -> full colour with an urgent badge
Item {
  id: root

  property color color: Color.foreground
  property color urgentColor: Color.urgent
  property real iconSize: Style.font.icon

  // Item already supplies the public string `state` property.
  state: "disconnected"
  implicitWidth: iconSize
  implicitHeight: iconSize
  width: iconSize
  height: iconSize

  readonly property bool urgent: state === "warning" || state === "error"
  readonly property bool connecting: state === "connecting"
  readonly property bool off: state === "disconnected"

  property real pulse: 1

  SequentialAnimation on pulse {
    running: root.connecting
    loops: Animation.Infinite
    NumberAnimation { to: 0.35; duration: 650; easing.type: Easing.InOutSine }
    NumberAnimation { to: 1.0; duration: 650; easing.type: Easing.InOutSine }
  }

  Image {
    id: mole
    anchors.fill: parent
    source: Qt.resolvedUrl("assets/mole.svg")
    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
    fillMode: Image.PreserveAspectFit
    smooth: true
    visible: false
    layer.enabled: true
  }

  MultiEffect {
    anchors.fill: mole
    source: mole
    saturation: root.off || root.connecting ? -1.0 : 0.0
    opacity: root.connecting ? root.pulse : (root.off ? 0.55 : 1.0)
  }

  Rectangle {
    visible: root.urgent
    width: Math.max(4, Math.round(root.iconSize * 0.38))
    height: width
    radius: width / 2
    color: root.urgentColor
    border.width: 1
    border.color: Qt.rgba(0, 0, 0, 0.35)
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: -Math.round(width * 0.15)
    anchors.bottomMargin: -Math.round(width * 0.15)
  }
}
