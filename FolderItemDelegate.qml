import QtQuick
import QtQuick.Controls

Rectangle {
    id: rootItem

    color: "#fff"
    border.width: 1
    border.color: "#ccd"
    radius: 10

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
        onEntered: {
            rootItem.color = "#eea"
            if (params.type !== "directory")
                iconButton.visible = false
        }
        onExited: {
            rootItem.color = "#fff"
            if (params.type !== "directory")
                iconButton.visible = true
        }
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
        font.pointSize: 22
        color: params.type === "directory" ? "#444" : "#41cd52"
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
