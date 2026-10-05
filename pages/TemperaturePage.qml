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
{
"name": "Kjøleskapet",
"serviceName": "com.victronenergy.temperature.virtual_b73fa283fe225243",
"instance": 101
},
{
"name": "Fryseren",
"serviceName": "com.victronenergy.temperature.virtual_319a2e76e5fe8c77",
"instance": 102
},
{
"name": "Soverommet",
"serviceName": "com.victronenergy.temperature.virtual_76fefb4d7c2b084c",
"instance": 103
},
{
"name": "Foran",
"serviceName": "com.victronenergy.temperature.virtual_91803acc929bc79e",
"instance": 104
}
]

Rectangle {
width: 300
height: 150
radius: 16
color: Theme.color_background_secondary

VeQuickItem {
id: temperatureItem
uid: BackendConnection.serviceUidFromName(
modelData.serviceName,
modelData.instance
) + "/Temperature"

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
