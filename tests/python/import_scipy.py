import scipy

# Ensure that the `arpack` directory does not interfere with the module. See
# #223.
import scipy.sparse.linalg._eigen.arpack.arpack
