"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

include("chain.jl")
include("util.jl")

# Using
import .ChainModule

# Functions
function main()

    println("Inicio")   

    # Create BlockChain
    blockchain = ChainModule.Chain()

    # Create Blocks
    block1 = ChainModule.BlockModule.Block()
    block2 = ChainModule.BlockModule.Block()
    block3 = ChainModule.BlockModule.Block()

    # Some Outputs
    Output1 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(10, "Carla")
    Output2 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(20, "Carla")
    Output3 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(23, "Carla")
    Output4 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(20, "Fran")
    Output5 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(50, "Quattro")
    Output6 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(1, "Fran")
    Output7 = ChainModule.BlockModule.TransactionModule.OutputModule.Output(100, "Quattro")

    # Some Inputs 
    Input1 = ChainModule.BlockModule.TransactionModule.InputModule.Input("tx_id_1", 1, "Quattro")
    Input2 = ChainModule.BlockModule.TransactionModule.InputModule.Input("tx_id_1", 2, "Quattro")
    Input3 = ChainModule.BlockModule.TransactionModule.InputModule.Input("tx_id_1", 3, "Carla")
    Input4 = ChainModule.BlockModule.TransactionModule.InputModule.Input("tx_id_1", 4, "Quattro")
    Input5 = ChainModule.BlockModule.TransactionModule.InputModule.Input("tx_id_1", 5, "Carla")

    # Transactions
    tx1 = ChainModule.BlockModule.TransactionModule.Tx()
    tx2 = ChainModule.BlockModule.TransactionModule.Tx()
    tx3 = ChainModule.BlockModule.TransactionModule.Tx()

    # Add them to the blockchain
    ChainModule.BlockModule.TransactionModule.AddInput(tx1, Input1)
    ChainModule.BlockModule.TransactionModule.AddInput(tx1, Input2)
    ChainModule.BlockModule.TransactionModule.AddInput(tx1, Input3)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx2, Output7)

    ChainModule.BlockModule.TransactionModule.AddInput(tx2, Input1)
    ChainModule.BlockModule.TransactionModule.AddInput(tx2, Input2)
    ChainModule.BlockModule.TransactionModule.AddInput(tx2, Input3)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx2, Output1)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx2, Output5)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx2, Output3)

    
    ChainModule.BlockModule.AddTx(block1, tx1)
    ChainModule.BlockModule.AddTx(block1, tx2)
    ChainModule.BlockModule.AddTx(block2, tx3)

    ChainModule.AddBlock(blockchain, block1)
    ChainModule.AddBlock(blockchain, block2)
    ChainModule.AddBlock(blockchain, block3)

    destinations = Array{Dict{String, Any}}(undef, 0)
    push!(destinations, Dict(dest_str => "Fran", value_str => 10.0))
    ChainModule.Transfer(blockchain, "Quattro", destinations)

    println("Fin")
end


main()
