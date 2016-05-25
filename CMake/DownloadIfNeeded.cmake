# DOWNLOAD_URL:STRING URL to download
# DOWNLOAD_AS:FILEPATH to target filename

# For now, we'll always download the file. We need to add logic to only download
# when the URL has changed.
message("Downloading ${DOWNLOAD_URL}")
file(DOWNLOAD "${DOWNLOAD_URL}" "${DOWNLOAD_AS}" STATUS result)
if(NOT result EQUAL "0")
  message(FATAL_ERROR "Failed to download ${DOWNLOAD_URL}")
endif()
