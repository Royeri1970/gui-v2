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
"instance": 101,
"batteryServiceName": "com.victronenergy.battery.virtual_101d6d7f7f457b2b",
"batteryInstance": 101
},
{
"name": "Fryseren",
"serviceName": "com.victronenergy.temperature.virtual_319a2e76e5fe8c77",
"instance": 102,
"batteryServiceName": "com.victronenergy.battery.virtual_03d6c144020d20df",
"batteryInstance": 100
},
{
"name": "Soverommet",
"serviceName": "com.victronenergy.temperature.virtual_76fefb4d7c2b084c",
"instance": 103,
"batteryServiceName": "com.victronenergy.battery.virtual_5fedd8f2e086ab12",
"batteryInstance": 102
},
{
"name": "Foran",
"serviceName": "com.victronenergy.temperature.virtual_91803acc929bc79e",
"instance": 104,
"batteryServiceName": "com.victronenergy.battery.virtual_154dd133fbac3227",
"batteryInstance": 103
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

VeQuickItem {
id: socItem
uid: BackendConnection.serviceUidFromName(
modelData.batteryServiceName,
modelData.batteryInstance
) + "/Soc"
}

Column {
anchors.centerIn: parent
spacing: 6

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

Label {
anchors.horizontalCenter: parent.horizontalCenter
text: isNaN(Number(socItem.value))
? "Batteri: -- %"
: "Batteri: " + Math.round(Number(socItem.value)) + " %"
color: Theme.color_font_secondary
font.pixelSize: 18
}
}
}
}
}
}
