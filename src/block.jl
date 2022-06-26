module BlockModule

# Includes    
include("transaction.jl")
include("util.jl")

# Imports
import .TransactionModule

# Structs
mutable struct Block
    # Header
    prev_block::String  # El hash del bloque completo que antecede al bloque actual en la Algochain.
    txns_hash::String  # El hash de todas las transacciones incluidas en el bloque.
    bits::Int  # Valor entero positivo que indica la dificultad con la que fue minada este bloque.
    nonce::Int  # Un valor entero no negativo que puede contener valores arbitrarios. El objetivo de este 
    # campo es tener un espacio de prueba modificable para poder generar hashes sucesivos hasta 
    # satisfacer la dificultad del minado.
    # Body
    txn_count::Int
    txns::Array{TransactionModule.Tx}
    Block(prev_block="default_prev_block", txns_hash="default_txns_hash", bits=0, nonce=0, txn_count=0, txns=Array{TransactionModule.Tx}[]
    ) = new(prev_block, txns_hash, bits, nonce, txn_count, txns)
end

function Genesis(value::Float64, addr::String)
    block = Block()
    block.prev_block = "F"^32
    AddTx(block, TransactionModule.Genesis(value, addr))
    return block
end

function AddTx(block::Block, txn::TransactionModule.Tx)
    block.txn_count = block.txn_count + 1
    push!(block.txns, txn)
end

function ToString(block::Block)
    bits_string = string(block.bits)
    nonce_string = string(block.nonce)
    txn_count_string = string(block.txn_count)
    txns_string = ArrayTxToString(block.txns)
    return string(block.prev_block, "\n", block.txns_hash, "\n", bits_string, "\n", nonce_string, "\n", txn_count_string, "\n", txns_string)
end

function ArrayTxToString(txns::Array{TransactionModule.Tx})
    txns_string::String = ""
    for tx_iter in txns
        txns_string = txns_string * TransactionModule.ToString(tx_iter)
    end
    return txns_string
end

function FindInputsByAddr(block::Block, addr::String)
    found_inputs = Array{TransactionModule.InputModule.Input}(undef, 0)
    for tx_iter in block.txns
        append!(found_inputs, TransactionModule.FindInputsByAddr(tx_iter, addr))
    end
    return found_inputs
end

function FindOutputsByAddr(block::Block, addr::String)
    found_outputs = Array{TransactionModule.OutputModule.Output}(undef, 0)
    for tx_iter in Block.txns
        append!(found_outputs, TransactionModule.FindOutputsByAddr(tx_iter, addr))
    end
    return found_outputs
end

function FindOutputsInfoByAddr(block::Block, addr::String)
    outputs_info = Array{Dict{String,Any}}(undef, 0)
    for tx_iter in block.txns
        append!(outputs_info, TransactionModule.FindOutputsInfoByAddr(tx_iter, addr))
    end

    return outputs_info
end

function FindTx(block::Block, addr::String)
    for tx_iter in Block.txns
        tx_string = TransactionModule.ToString(tx_iter)
        hash = Util.HashString(tx_string)
        if cmp(hash, addr) == 0
            return tx_string
        end
    end
    return false
end

function LoadBlock(file::IOStream)

    block = Block()
    block.prev_block = readline(file)
    block.txns_hash = readline(file)
    block.bits = parse(Int, readline(file))
    block.nonce = parse(Int, readline(file))

    txn_count = parse(Int, readline(file))

    for _ in 1:txn_count
        tx = TransactionModule.LoadTx(file)
        if tx == false
            return false
        end
        AddTx(block, tx)
    end

    if txn_count != length(block.txns)
        return false
    end

    return block
end

function MineBlock(block::Block, bits::Int)
    proof_of_work = "0"^bits * ".*"
    block = chain.blocks_array[0]
    while (c)
    
end


end # module Block
