SET(SUBPACKAGES_DIRS_CLASSIFICATIONS_OPTREQS)
SET(LIB_REQUIRED_DEP_PACKAGES)
SET(LIB_OPTIONAL_DEP_PACKAGES)
SET(TEST_REQUIRED_DEP_PACKAGES)
SET(TEST_OPTIONAL_DEP_PACKAGES)
SET(LIB_REQUIRED_DEP_TPLS BLAS LAPACK)
SET(LIB_OPTIONAL_DEP_TPLS)
SET(TEST_REQUIRED_DEP_TPLS)
SET(TEST_OPTIONAL_DEP_TPLS)

TRIBITS_ALLOW_MISSING_EXTERNAL_PACKAGES(${LIB_REQUIRED_DEP_PACKAGES} ${LIB_OPTIONAL_DEP_PACKAGES})
