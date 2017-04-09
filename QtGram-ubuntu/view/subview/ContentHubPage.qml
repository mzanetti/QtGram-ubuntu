import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
    id: root

    property string source
    property alias handler: picker.handler
    property alias contentType: picker.contentType

    signal filesImported(var fileList)

    header: PageHeader {
        title: root.handler == ContentHandler.Share ? "Share image" : "Open image"
    }

    Component {
        id: exportItemComponent
        ContentItem {
            name: i18n.tr("Contenthub Test Item")
        }
    }

    ContentPeerPicker {
        id: picker
        anchors.fill: parent
        anchors.topMargin: root.header.height
        showTitle: false

        onPeerSelected: {
            peer.selectionType = ContentTransfer.Multiple
            var transfer = peer.request();
            switch (picker.handler) {
            case ContentHandler.Source:
                transfer.stateChanged.connect(function() {
                    switch (transfer.state) {
                    case ContentTransfer.Charged:
                        var fileList = []
                        for (var i = 0; i < transfer.items.length; i++) {
                            fileList.push(transfer.items[i].url)
                        }
                        root.filesImported(fileList)
                        apl.removePages(root)
                        break;
                    case ContentTransfer.Aborted:
                        apl.removePages(root)
                        break;
                    }
                })
                break;
            case ContentHandler.Destination:
            case ContentHandler.Share:
                if (transfer.state === ContentTransfer.InProgress) {
                    var items = []
                    var exportItem = exportItemComponent.createObject();
                    exportItem.url = root.source;
                    exportItem.text = "image";
                    items.push(exportItem);
                    transfer.items = items;
                    transfer.state = ContentTransfer.Charged;
                    transfer.stateChanged.connect(function(state) {if (state === ContentTransfer.Finalized) exportItem.destroy()});
                    apl.removePages(root)
                }
            }
        }
    }
}
