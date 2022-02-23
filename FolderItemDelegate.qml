import QtQuick
import QtQuick.Controls

Rectangle {
    id: rootItem

    color: "#fff"
    border.width: 1
    border.color: "#ccd"
    radius: 10

    signal openDir(var dirs, string dirName)
    signal openFile(string fileName, string fileUrl)

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {
            if (params.type !== "directory")
                iconButton.visible = false
        }
        onExited: {
            if (params.type !== "directory")
                iconButton.visible = true
        }
        onClicked: {
            if (params.type === "directory") {
                rootItem.openDir(params.children, params.name)
            } else {
                rootItem.openFile(params.name, params.url)
            }
        }

    }

    IconButton {
        id: iconButton

        text: params.type === "directory" ? MaterialIcons.mdiFolder : MaterialIcons.mdiFileDocument
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: false
        hoverEnabled: false
        font.pointSize: 22
        anchors {
            top: parent.top
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: fileNameText

        text: params.name
        color: iconButton.color
        width: parent.width * 0.85
        font.pointSize: iconButton.visible ? 8 : 9
        height: iconButton.visible ? 20 : parent.height
        elide: iconButton.visible ? Qt.ElideRight : Qt.ElideNone
        wrapMode: iconButton.visible ? Text.NoWrap : Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: iconButton.visible ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: iconButton.visible ? Text.AlignVCenter : Text.AlignTop
        anchors {
            horizontalCenter: iconButton.visible ? parent.horizontalCenter : undefined
            top: iconButton.visible ? iconButton.bottom : parent.top
            topMargin: iconButton.visible ? -5 : 10
            left: iconButton.visible ? undefined : parent.left
            leftMargin: iconButton.visible ? undefined : 3
        }
    }
}
