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

    # Bloque genesis
    genesis_block = ChainModule.BlockModule.Block()
    output = ChainModule.BlockModule.TransactionModule.OutputModule.Output(1000, "Banco")
    input = ChainModule.BlockModule.TransactionModule.InputModule.Input()
    tx = ChainModule.BlockModule.TransactionModule.Tx()
    ChainModule.BlockModule.TransactionModule.AddInput(tx, input)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx, output)
    ChainModule.BlockModule.AddTx(genesis_block, tx)
    ChainModule.AddBlock(blockchain, genesis_block)

    # Destinations
    destinations = Array{Dict{String, Any}}(undef, 0)
    push!(destinations, Dict(addr_str => "Fran", value_str => 20.0))
    push!(destinations, Dict(addr_str => "Carla", value_str => 55.0))
    push!(destinations, Dict(addr_str => "Quattro", value_str => 200.0))

    # Trasnfer
    ChainModule.Transfer(blockchain, "Banco", destinations)

    for dst_iter in destinations 

        balance, outputs_info = ChainModule.GetBalance(blockchain, dst_iter[addr_str])

        println("Balance de ", dst_iter[addr_str], " es " , balance)
    end

    destinations = Array{Dict{String, Any}}(undef, 0)
    push!(destinations, Dict(addr_str => "Lola", value_str => 12.0))
    push!(destinations, Dict(addr_str => "Fran", value_str => 65.0))

    ChainModule.MineAndAddMempool(blockchain, 2)

    ChainModule.Transfer(blockchain, "Quattro", destinations)

    for dst_iter in destinations 

        balance, outputs_info = ChainModule.GetBalance(blockchain, dst_iter[addr_str])

        println("Balance de ", dst_iter[addr_str], " es " , balance)
    end
    balance, outputs_info = ChainModule.GetBalance(blockchain, "Quattro")

        println("Balance de ", "Quattro", " es " , balance)
    println("Fin")
end


main()
