include(LiriQDoc)

liri_install_doc("${CMAKE_CURRENT_SOURCE_DIR}/fluid.qdocconf" OUTPUT_DIRECTORY_VARIABLE _doc_output_dir)
if(_doc_output_dir)
    install(DIRECTORY "${_doc_output_dir}" DESTINATION "${INSTALL_DOCDIR}/fluid/html")
endif()
