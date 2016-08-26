# Regular expression for warning exception during build process.
list(APPEND CTEST_CUSTOM_WARNING_EXCEPTION
  # Ignore all warnings when CTEST_CUSTOM_MAXIMUM_NUMBER_OF_WARNINGS doesn't
  # have any effect.
  ".*"
  ".ParaViewSuperbuild.*"
  "[w|W]arning"
  "WARNING"
  "CMake Warning")

# Regular expression for error exceptions during build process.
list(APPEND CTEST_CUSTOM_ERROR_EXCEPTION
  # Skip numpy configure errors on Windows. These are warnings about Atlas/Blas
  # not found.
  "system_info.py.*UserWarning:"
  # "Unknown distribution option: 'test_suite'"
  # "Unknown distribution option: 'define_macros'"
  "dist.py.*UserWarning:"

  # Again from numpy, skip configtest errors.
  "_configtest")
