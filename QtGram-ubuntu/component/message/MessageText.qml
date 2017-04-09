import QtQuick 2.4
import Ubuntu.Components 1.3
import "../../js/TextElaborator.js" as TextElaborator

Label
{
    readonly property real calculatedWidth: implicitWidth
    property bool openUrls: true
    property string emojiPath
    property string rawText

    id: messagetext
    textFormat: Text.StyledText
    text: TextElaborator.elaborate(rawText, emojiPath, font.pixelSize, "#888888", openUrls)
//    text: rawText
    verticalAlignment: Text.AlignTop

    onLinkActivated: {
        if(!openUrls)
            return;

        Qt.openUrlExternally(link);
    }
}
