import QtQuick
import QtQuick.Controls

ItemDelegate {
    implicitHeight: 50
    implicitWidth: metrics.advanceWidth + 10

    Rectangle {
        color: index === breadcrumb.currentIndex ? "#eea" : "transparent"
        anchors.fill: parent
    }

    onClicked: stackView.gotoNavigation(dirUuid)

    TextMetrics {
        id: metrics
        text: label.text
    }

    Label {
        id: label

        text: dirName
        font.pointSize: 8
        color: homeLabel.color
        anchors.centerIn: parent
    }
}
