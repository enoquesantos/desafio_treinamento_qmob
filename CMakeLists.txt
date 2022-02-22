cmake_minimum_required(VERSION 3.16)

project(desafio_treinamento_qmob VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Core Gui Widgets Quick Network REQUIRED)

qt_add_executable(appdesafio_treinamento_qmob
    main.cpp
    resources.qrc
)

set(PROJECT_SOURCES
        resources.qrc
)


qt_add_qml_module(appdesafio_treinamento_qmob
    URI
        desafio_treinamento_qmob
    VERSION
        1.0
    QML_FILES
        main.qml
        FolderItemDelegate.qml
        IconButton.qml
    SOURCES
        materialicons.h
        backend.h
        backend.cpp
        httprequest.h
        httprequest.cpp
        materialdesignicons-webfont.ttf
    RESOURCES
        resources.qrc
)

set_target_properties(appdesafio_treinamento_qmob PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER desafio_treinamento_qmob.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(appdesafio_treinamento_qmob
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appdesafio_treinamento_qmob
    PRIVATE Qt6::Core Qt6::Gui Qt6::Quick Qt6::Widgets Qt6::Network)
