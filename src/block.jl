module BlockModule

# Includes    
include("transaction.jl")
include("util.jl")

# Imports
import SHA
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
    block.prev_block = "F"^64
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

function MineBlock(block::Block, bits::Int, prev_block::String)
    block.txns_hash = HashString(ArrayTxToString(block.txns))
    block.prev_block = prev_block
    while (CheckBits(bits, ToString(block)) == false)
        block.nonce += 1
    end
    return HashString(ToString(block))
end

function CheckBits(bits::Int, block_string::String)
    zeros_uint8 = UInt8(0)
    ones_uint8 = UInt8(0b11111111)
    quotient = bits ÷ 8
    remaind = bits % 8
    hash = SHA.sha256(block_string)
    for i in 1:quotient
        if (ones_uint8 & hash[i] != zeros_uint8)
            return false
        end
    end
    bin_remaind = 2^remaind - 1
    uint_bin_remaind = UInt8(bin_remaind)
    if (uint_bin_remaind & hash[quotient+1] == uint_bin_remaind)
        return true
    else
        return false
    end
end

end # module Block
