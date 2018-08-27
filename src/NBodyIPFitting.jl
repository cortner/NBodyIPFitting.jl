#
# TODO
#  * change datatypes => observationtypes
#  * load the kron_groups on demand
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

include("fio.jl")

include("prototypes.jl")

include("datatypes.jl")

# loading data
include("data.jl")
@reexport using NBodyIPFitting.Data

include("lsq_db.jl")
@reexport using NBodyIPFitting.DB

include("lsqerrors.jl")
@reexport using NBodyIPFitting.Errors

include("lsq.jl")
@reexport using NBodyIPFitting.Lsq

# #visualisation module
# include("PIPplot.jl")
# @reexport using NBodyIPs.PIPplot

end # module