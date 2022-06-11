"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

# Includes
include("transaction.jl")

# Using
import .Transaction

# Functions
function main()

    println("Inicio")

    # Create Object
    tx_obj = Transaction.Tx()

    # Initialize Inputs
    for i in 1:10
        Transaction.AddInput(tx_obj, i)
    end

    # Initialize Outputs
    for i in 5:15
        Transaction.AddOutput(tx_obj, i)
    end

    println("Inputs Array = ", tx_obj.inputs_array)
    println("Outputs Array = ", tx_obj.outputs_array)

    # look for inputs-outputs
    println("FindOutput = ", Transaction.FindOutput(tx_obj, 5))
    println("FindOutput = ", Transaction.FindOutput(tx_obj, 30))
    println("FindOutput = ", Transaction.FindInput(tx_obj, 5))

    # Print HashTx
    println("ToString = \n", Transaction.ToString(tx_obj))

    # End
    println("Fin")
end


main()