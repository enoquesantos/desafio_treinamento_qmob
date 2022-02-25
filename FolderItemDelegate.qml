import QtQuick
import QtQuick.Controls

Rectangle {
    id: rootItem

    color: "transparent"
    border.width: 0

    signal openDir(var _children, string uuid, string name)
    signal openFile(string fileName, string fileUrl)

    function getIcon() {
        if (params.type !== "directory") {
            const fileExt = params.name.substr(params.name.length - 4)

            if (fileExt.indexOf("py") > -1)
                return MaterialIcons.mdiCodeArray

            if (fileExt.indexOf("cpp") > -1)
                return MaterialIcons.mdiCodeString

            if (fileExt.indexOf(".h") > -1)
                return MaterialIcons.mdiCodeBraces

            return MaterialIcons.mdiFileDocument
        }
        return MaterialIcons.mdiFolder
    }

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: iconButton.color = "#e3bbbd"
        onExited: iconButton.color = "#97976a"
        onPressedChanged: iconButton.color = pressed ? "#6f5e4f" : "#97976a"
        onClicked: {
            if (params.type === "directory") {
                rootItem.openDir(params.children, params.uuid, params.name)
            } else {
                rootItem.openFile(params.name, params.url)
            }
        }
    }

    IconButton {
        id: iconButton

        text: getIcon()
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: false
        hoverEnabled: false
        font.pointSize: 35
        color: params.type === "directory" ? "#97976a" : "#df949d"
        anchors {
            top: parent.top
            topMargin: 2
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: fileNameText

        text: params.name
        color: iconButton.color
        opacity: iconButton.opacity
        width: parent.width * 0.85
        font.pointSize: 9
        height: 20
        elide: Qt.ElideRight
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: iconButton.bottom
            topMargin: -5
        }
    }
}
