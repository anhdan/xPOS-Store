cmake_minimum_required(VERSION 3.5)

project(xPOS-Store-CMake LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#=====<Dando> Add target name
set(target_name "xPOS-Store-CMake")

# Add include path
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBUILD_TESTING=OFF")
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories( "/usr/include" )
link_directories( "/usr/lib" )
set(ADDITIONAL_LIBS pthread sqlite3)


set(FIREBASE_CPP_SDK_DIR "/home/martin/Workspace/xPOS/src/firebase-cpp-sdk")
if(NOT EXISTS ${FIREBASE_CPP_SDK_DIR})
  message(FATAL_ERROR "The Firebase C++ SDK directory does not exist: ${FIREBASE_CPP_SDK_DIR}. See the readme.md for more information")
endif()

# Add the Firebase libraries to the target using the function from the SDK.
add_subdirectory(${FIREBASE_CPP_SDK_DIR} bin/ EXCLUDE_FROM_ALL)
# Note that firebase_app needs to be last in the list.
set(firebase_libs firebase_functions firebase_auth firebase_app)
#=======================================

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

if(ANDROID)
    add_library(${target_name} SHARED
      main.cpp
      qml.qrc
    )
else()
    add_executable(${target_name}
      main.cpp
      backend/xPos.cpp
      backend/containers/Product.cpp
      backend/containers/Customer.cpp
      backend/containers/Staff.cpp
      backend/containers/Person.cpp
      backend/database/Database.cpp
      backend/database/InventoryDatabase.cpp
      backend/XPBackend.cpp
      backend/3rd/key_emitter.cpp
      backend/database/UserDatabase.cpp
      backend/database/SellingDatabase.cpp
      backend/containers/SellingRecord.cpp
      backend/containers/Bill.cpp
      backend/containers/WorkShift.cpp
      backend/containers/Payment.cpp
      qml.qrc
    )
endif()

target_compile_definitions(${target_name}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
#<Dando> Add firebase lib and additional lib
target_link_libraries(${target_name}
    PRIVATE Qt5::Core Qt5::Quick "${firebase_libs}" ${ADDITIONAL_LIBS})
