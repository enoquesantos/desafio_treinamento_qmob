import QtQuick
import QtQuick.Controls

ToolButton {
    id: control

    implicitHeight: 50
    implicitWidth: 50
    font.pointSize: 18
    font.family: "Material Design Icons"
    flat: true
    display: AbstractButton.TextOnly
    contentItem: Text {
        id: text

        text: control.text
        font: control.font
        color: "#444"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    property alias color: text.color
}
