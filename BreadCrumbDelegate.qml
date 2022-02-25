import QtQuick
import QtQuick.Controls

ItemDelegate {
    hoverEnabled: true
    implicitHeight: 50
    implicitWidth: metrics.advanceWidth < 50 ? 50 : metrics.advanceWidth

    Rectangle {
        id: backgroundRect
        color: index === breadcrumb.currentIndex ? "#22aa20" : "#41cd52"
        anchors.fill: parent
    }

    onClicked: stackView.gotoNavigation(dirUuid)
    onHoveredChanged: backgroundRect.color = hovered ? "#22aa20" : "#41cd52"

    TextMetrics {
        id: metrics
        text: label.text
    }

    Label {
        id: label

        text: dirName
        color: homeLabel.color
        anchors.centerIn: parent
        font.pointSize: homeLabel.font.pointSize
    }
}
