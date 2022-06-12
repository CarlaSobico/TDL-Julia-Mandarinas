"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

include("transaction.jl")
include("util.jl")

# Using
import .TransactionModule

# Functions
function main()

    println("Inicio")

    # Create Transaction
    tx_obj = TransactionModule.Tx()

    # Initialize some Inputs
    input_obj = TransactionModule.InputModule.Input("tx_id_1", 2, "Carla")
    TransactionModule.AddInput(tx_obj, input_obj)

    input_obj = TransactionModule.InputModule.Input("tx_id_2", 1, "Carla")
    TransactionModule.AddInput(tx_obj, input_obj)

    input_obj = TransactionModule.InputModule.Input("tx_id_3", 5, "Fran")
    TransactionModule.AddInput(tx_obj, input_obj)

    input_obj = TransactionModule.InputModule.Input("tx_id_4", 1, "Carla")
    TransactionModule.AddInput(tx_obj, input_obj)

    # Some Default Inputs
    for i in 1:5
        input_obj = TransactionModule.InputModule.Input()
        TransactionModule.AddInput(tx_obj, input_obj)
    end

    # Initialize Some Outputs
    output_obj = TransactionModule.OutputModule.Output(100, "Carla")
    TransactionModule.AddOutput(tx_obj, output_obj)

    output_obj = TransactionModule.OutputModule.Output(1500, "4")
    TransactionModule.AddOutput(tx_obj, output_obj)

    # Some Default Outputs
    for i in 1:3
        output_obj = TransactionModule.OutputModule.Output()
        TransactionModule.AddOutput(tx_obj, output_obj)
    end

    # Print Transaccion
    println("Print Transaction = \n", TransactionModule.ToString(tx_obj))

    # Look for outpoints
    outpoints_array = TransactionModule.FindOutpointsByAddr(tx_obj, "Carla")
    println("FindOutpoints = \n", outpoints_array[1][tx_id_str])

    # Look for outputs



    # End
    println("Fin")
end


main()
