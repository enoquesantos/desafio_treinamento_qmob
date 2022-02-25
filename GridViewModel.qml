import QtQuick
import QtQuick.Controls

GridView {
    id: gridView

    property var modelData
    property StackView stackView

    model: ListModel {
        id: gridViewModel
    }
    snapMode: GridView.SnapToRow
    delegate: FolderItemDelegate {
        width: gridView.cellWidth
        height: gridView.cellHeight
        onOpenDir: function(_children, uuid, name) {
            const args = {
                modelData: _children,
                stackView: stackView
            }

            stackView.openNavigation(uuid, name, args)
        }
        onOpenFile: function(fileName, fileUrl) {
            Qt.openUrlExternally(fileUrl)
        }
    }

    Component.onCompleted: {
        if (!Array.isArray(modelData)) {
            modelData = [modelData]
        }
        for (var i = 0; i < modelData.length; ++i) {
            gridViewModel.append({params: modelData[i]})
        }
    }
}
