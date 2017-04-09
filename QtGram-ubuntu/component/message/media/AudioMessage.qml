import QtQuick 2.4
import LibQTelegram 1.0
import Ubuntu.Components 1.3

Item
{
    readonly property real contentWidth: waveform.contentWidth
    property alias barColor: waveform.barColor
    property alias source: waveform.message
    property string duration

    id: audiomessage
    height: waveform.height + lblduration.contentHeight

    Icon
    {
        id: imgplay
        width: units.gu(4)
        height: width
        anchors { verticalCenter: parent.verticalCenter; verticalCenterOffset: units.gu(1) }
        name: "media-playback-start"

        ActivityIndicator { z: 2; anchors.centerIn: parent; running: mediamessageitem.downloading }
        MouseArea { anchors.fill: parent; onClicked: mediamessageitem.download() }
    }

    Waveform
    {
        id: waveform
        anchors { left: imgplay.right; top: parent.top; topMargin: units.gu(1); right: parent.right; leftMargin: units.gu(1) }
        height: units.gu(4)
    }

    Label
    {
        id: lblduration
        anchors { left: imgplay.right; top: waveform.bottom; right: parent.right; leftMargin: units.gu(1); topMargin: units.gu(1) }
        fontSize: "small"
        text: audiomessage.duration + " <font color='" + waveform.barColor + "'>⚫</font>";
    }
}
