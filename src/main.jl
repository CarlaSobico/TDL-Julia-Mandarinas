"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

# Includes
include("transaction.jl")

# Using
using .Transaction

# Functions
function main()

    # Create Object
    tx_obj = Tx()
    println(tx_obj.n_tx_in)

    # Change Attribute Value
    tx_obj.n_tx_in = 4
    println(tx_obj.n_tx_in)

    # Call function in other module
    test()
end


main()