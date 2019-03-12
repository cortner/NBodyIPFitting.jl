#
# TODO
#  * change datatypes => observationtypes
#  * load the kron_groups on demand (mmap)
#  * create LsqSettings struct => to store inside IP
#    as well as pass around the hooks
#

"""
# `NBodyIPFitting.jl`

Package for defining and fitting interatomic potentials based on the
N-Body expansion (ANOVA, HDMR, ...). The main exported type is
`NBodyIP` which is a `JuLIP` calculator.

See `?...` on how to
* `?NBodyIPFitting.Fitting` : fit an `NBodyIP`
* `?NBodyIPFitting.Data` : load data sets
* `?NBodyIPFitting.IO` : write and read an `NBodyIP`
"""
module NBodyIPFitting

using Reexport

include("tools.jl")

include("prototypes.jl")

include("obsiter.jl")

include("datatypes.jl")

# loading data
include("data.jl")
@reexport using NBodyIPFitting.Data

include("lsq_db.jl")
@reexport using NBodyIPFitting.DB
# export LsqDB

include("filtering.jl")
@reexport using NBodyIPFitting.Filtering

include("lsqerrors.jl")
@reexport using NBodyIPFitting.Errors

include("lsq.jl")
@reexport using NBodyIPFitting.Lsq

include("regularisers.jl")
@reexport using NBodyIPFitting.Regularisers

include("weights.jl")
@reexport using NBodyIPFitting.Weights

# TODO: move this into NBodyIPs or a separate module 
# #visualisation module
# include("PIPplot.jl")
# @reexport using NBodyIPs.PIPplot

end # module
