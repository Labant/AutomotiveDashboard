cmake_minimum_required(VERSION 3.16)
project(AutomotiveDashboard VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(AutomotiveDashboard
    main.cpp
    VehicleData.cpp
)

qt_add_qml_module(AutomotiveDashboard
    URI Dashboard
    VERSION 1.0
    QML_FILES
        Dashboard.qml
        Gauge.qml
        IndicatorPanel.qml
    SOURCES
        VehicleData.h
        VehicleData.cpp
)

target_link_libraries(AutomotiveDashboard PRIVATE Qt6::Quick)

set_target_properties(AutomotiveDashboard PROPERTIES
    WIN32_EXECUTABLE TRUE
)
