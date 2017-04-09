import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1
import "../../js/CountryList.js" as CountryList

Page {
    id: root
    property var context: null

    header: PageHeader {
        title: "Log in to Telegram"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: root.header.height + units.gu(2)
        anchors.margins: units.gu(2)
        spacing: units.gu(1)

        Label {
            text: "Insert your phone number"
            Layout.fillWidth: true
        }

        OptionSelector {
            id: cbcountries
            Layout.fillWidth: true
            model: CountryList.countries
            delegate: OptionSelectorDelegate {
                text: CountryList.countries[index].text
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "+"
            }

            TextField {
                id: tfcode
                text: CountryList.countries[cbcountries.selectedIndex].code
                Layout.preferredWidth: units.gu(8)
                onTextChanged: {
                    var index = CountryList.index[tfcode.text];

                    if(index === undefined)
                        cbcountries.selectedIndex = -1;
                    else
                        cbcountries.selectedIndex = index;
                }
            }
            TextField {
                id: tfphonenumber
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }
        Button {
            id: btnnext
            Layout.fillWidth: true
            text: "Next"
            enabled: tfphonenumber.text.length > 5
            color: UbuntuColors.green
            onClicked: {
                btnnext.text = "Sending request...";
                context.telegram.initializer.phoneNumber = "+" + tfcode.text + tfphonenumber.text;
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
