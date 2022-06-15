"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

include("chain.jl")
include("transaction.jl")
include("util.jl")

# Using
import .ChainModule
import .TransactionModule

# Functions
function main()

    println("Inicio")

    # Create BlockChain
    blockchain = ChainModule.Chain()

    # Init Blockchain con bloque genesis
    ChainModule.Init(blockchain, "Carla", 1000, 2)

    # Transfer
    destinations = Array{Dict{String, Any}}(undef, 0)
    push!(destinations, Dict{String, Any}(dest_str => "Fran", value_str => 20))
    push!(destinations, Dict{String, Any}(dest_str => "Quattro", value_str => 5))
    push!(destinations, Dict{String, Any}(dest_str => "Lola", value_str => 50))

    ChainModule.Transfer(blockchain, "Carla", destinations)

    # Mine
    bits = 5
    blockchain.mempool.txn_count = 1
    ChainModule.MineAndAddMempool(blockchain, bits)

    # Find Block
    println("FindBlock = ", ChainModule.FindBlock(blockchain, "block_id"))

    # # Create Transaction
    # tx_obj = TransactionModule.Tx()

    # # Initialize some Inputs
    # input_obj = TransactionModule.InputModule.Input("tx_id_1", 2, "Carla")
    # TransactionModule.AddInput(tx_obj, input_obj)

    # input_obj = TransactionModule.InputModule.Input("tx_id_2", 1, "Carla")
    # TransactionModule.AddInput(tx_obj, input_obj)

    # input_obj = TransactionModule.InputModule.Input("tx_id_3", 5, "Fran")
    # TransactionModule.AddInput(tx_obj, input_obj)

    # input_obj = TransactionModule.InputModule.Input("tx_id_4", 1, "Carla")
    # TransactionModule.AddInput(tx_obj, input_obj)

    # # Some Default Inputs
    # for i in 1:5
    #     input_obj = TransactionModule.InputModule.Input()
    #     TransactionModule.AddInput(tx_obj, input_obj)
    # end

    # # Initialize Some Outputs
    # output_obj = TransactionModule.OutputModule.Output(100, "Carla")
    # TransactionModule.AddOutput(tx_obj, output_obj)

    # output_obj = TransactionModule.OutputModule.Output(1500, "4")
    # TransactionModule.AddOutput(tx_obj, output_obj)

    # # Some Default Outputs
    # for i in 1:3
    #     output_obj = TransactionModule.OutputModule.Output()
    #     TransactionModule.AddOutput(tx_obj, output_obj)
    # end

    # # Print Transaccion
    # println("Print Transaction = \n", TransactionModule.ToString(tx_obj))

    # # Look for outpoints
    # outpoints_array = TransactionModule.FindOutpointsByAddr(tx_obj, "Carla")
    # println("FindOutpointsByAddr = ")
    # for outpoint in outpoints_array
    #     println(outpoint[tx_id_str], " ", outpoint[idx_str])
    # end

    # # Look for inputs
    # inputs_array = TransactionModule.FindInputsByAddr(tx_obj, "Fran")
    # println("FindInputsByAddr = ")
    # for input in inputs_array
    #     println(input.tx_id, " ", input.idx, " ", input.addr)
    # end

    # # Look for outputs
    # outputs_array = TransactionModule.FindOutputsByAddr(tx_obj, "Carla")
    # println("FindOutputsByAddr = ")
    # for output in outputs_array
    #     println(output.value, " ", output.addr)
    # end
    # # End
    println("Fin")
end


main()
