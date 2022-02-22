import QtQuick
import QtQuick.Controls

Rectangle {
    id: rootItem

    color: "#fff"
    border.width: 1
    border.color: "#ccd"
    radius: 10

    signal openDir(var dirs)
    signal openFile(var fileName)

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (params.type === "directory") {
                rootItem.openDir(params.children)
            } else {
                rootItem.openFile(params.name)
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 0

        IconButton {
            id: iconButton

            text: params.type === "directory" ? MaterialIcons.mdiFolder : MaterialIcons.mdiFileDocument
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: false
            hoverEnabled: false
        }

        Text {
            width: parent.width*0.70
            text: params.name
            elide: Qt.ElideRight
            wrapMode: Text.NoWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            color: iconButton.color
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
