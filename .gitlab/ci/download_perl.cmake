cmake_minimum_required(VERSION 3.12)

if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "windows")
  set(perl_url "https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/download/SP_5.39.10/strawberry-perl-5.39.10.1-64bit-portable.zip")
  set(perl_sha256_sum "ffe4f3ae5980f9410bf76eaad77d688f8b86ba6de77a11a3df896bdf00aca366")
  set(perl_ext zip)
else ()
  message(FATAL_ERROR "Unsupported platform for Perl")
endif ()

message("Downloading ${perl_url}")
set(outdir "${CMAKE_SOURCE_DIR}/.gitlab/perl")
set(archive_path "${outdir}/perl.${perl_ext}")

# Download and extract
file(DOWNLOAD ${perl_url} "${archive_path}" EXPECTED_HASH SHA256=${perl_sha256_sum})
file(ARCHIVE_EXTRACT INPUT "${archive_path}" DESTINATION "${outdir}" VERBOSE)
