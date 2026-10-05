import QtQuick
import Victron.VenusOS

SwipeViewPage {
id: root

title: "Temperaturer"
iconSource: "qrc:/images/levels.svg"
url: "qrc:/qt/qml/Victron/VenusOS/pages/TemperaturePage.qml"
topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive

Grid {
anchors.centerIn: parent
columns: 2
spacing: 20

Repeater {
model: [
{ "name": "Kjøleskapet", "instance": 101 },
{ "name": "Fryseren", "instance": 102 },
{ "name": "Soverommet", "instance": 103 },
{ "name": "Foran", "instance": 104 }
]

Rectangle {
width: 300
height: 150
radius: 16
color: Theme.color_background_secondary

readonly property var temperatureDevice:
Global.environmentInputs.model.deviceForDeviceInstance(modelData.instance)

VeQuickItem {
id: temperatureItem
uid: parent.temperatureDevice
? parent.temperatureDevice.serviceUid + "/Temperature"
: ""
sourceUnit: Units.unitToVeUnit(VenusOS.Units_Temperature_Celsius)
displayUnit: Units.unitToVeUnit(Global.systemSettings.temperatureUnit)
}

Column {
anchors.centerIn: parent
spacing: 10

Label {
anchors.horizontalCenter: parent.horizontalCenter
text: modelData.name
color: Theme.color_font_primary
font.pixelSize: 24
}

QuantityLabel {
anchors.horizontalCenter: parent.horizontalCenter
value: temperatureItem.value ?? NaN
unit: Global.systemSettings.temperatureUnit
font.pixelSize: 38
}
}
}
}
}
}
