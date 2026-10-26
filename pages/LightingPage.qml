import QtQuick
import Victron.VenusOS

SwipeViewPage {
    id: root

    title: "Belysning"
    iconSource: "qrc:/images/icon_switch_24.svg"
    url: "qrc:/qt/qml/Victron/VenusOS/pages/LightingPage.qml"
    topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive

    ListView {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        model: SortedIOChannelGroupModel {
            sourceModel: Global.switches.groups
            filterRole: IOChannelGroupModel.GroupNameRole
            filterRegularExpression: "^Belysning$"
        }

        delegate: IOChannelGroupCard {
            width: 620
        }
    }
}
