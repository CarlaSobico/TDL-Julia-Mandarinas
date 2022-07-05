module ChainModule

# Includes    

include("block.jl")
include("util.jl")

# Imports

import .BlockModule

# Structs

mutable struct Chain
    blocks_array::Array{BlockModule.Block}
    mempool::BlockModule.Block

    Chain(blocks_array=Array{BlockModule.Block}[], mempool=BlockModule.Block()) = new(blocks_array, mempool)
end

# Functions/Methods

# Iniciar BlockChain. Agregaga bloque genesis
function Init(chain::Chain, user::String, value::Float64, bits::Int)

    # Se borra la actual Blockchain y la mempool
    empty!(chain.blocks_array)
    chain.mempool = BlockModule.Block()

    # Obtener Genesis Block
    genesis_block = BlockModule.Genesis(value, user)
    AddBlock(chain, genesis_block)

    BlockModule.MineBlock(genesis_block, bits, genesis_block.prev_block)

    return HashString(BlockModule.ToString(genesis_block))
end

# Transfiere coins del usuario source a los destinatarios (si es posible)
function Transfer(chain::Chain, user_source::String, destinations_array::Array{Dict{String,Any}})

    # Se calcula la cantidad de coins a transferir entre todos los destinatarios
    needed_coins::Float64 = 0.0
    for destinations_iter in destinations_array
        needed_coins += destinations_iter[value_str]
    end

    # Balance del usuario y los outputs no referenciados
    user_balance, user_available_outputs = GetBalance(chain, user_source)

    # Se verifica que se haya encontrado al usuario y que tenga suficientes coins
    if user_balance == fail_str || needed_coins > user_balance
        return fail_str
    end

    # Se crea la transaccion a partir de los ouputs disponibles del usuario y se agrega a la mepool
    tx = BlockModule.TransactionModule.CreateTransaction(user_source, needed_coins, user_available_outputs, destinations_array)
    BlockModule.AddTx(chain.mempool, tx)

    return HashString(BlockModule.TransactionModule.ToString(tx))
end

# Agrega lo guardado en la mempool hasta el momento en la Blockchain minando el bloque con bits de dificultad
function MineAndAddMempool(chain::Chain, bits::Int)

    # Solo se agrega si la mempool tiene alguna transaccion
    result = fail_str

    if chain.mempool.txn_count > 0

        # Se agrega el bloque a la Blockchain
        prev_block_hash = HashString(BlockModule.ToString(chain.blocks_array[end]))
        result = BlockModule.MineBlock(chain.mempool, bits, prev_block_hash)
        AddBlock(chain, chain.mempool)

        # Se reinicia la mepool
        chain.mempool = BlockModule.Block()
    end

    return result
end

# Devuelve la cantidad de coins del usuario. false si no encuentra al usuario y la info de los outputs de donde extraerlos
function GetBalance(chain::Chain, user_source::String)

    # Se obtienen los inputs del usuario
    user_inputs_array = FindInputsByAddr(chain, user_source)

    # Se obtienen la info de los outputs del usuario
    user_outputs_info_array = FindOutputsInfoByAddr(chain, user_source)

    # Se verifica que el usuario exista
    if (length(user_inputs_array) == 0) && (length(user_outputs_info_array) == 0)
        return fail_str, user_outputs_info_array
    end

    # Se eliminan los outputs que ya fueron referenciados a un input
    for input_iter in user_inputs_array
        indexes_to_delete = findall(
            output_info_elem -> (output_info_elem[tx_id_str] == input_iter.tx_id && output_info_elem[idx_str] == input_iter.idx), user_outputs_info_array)

        deleteat!(user_outputs_info_array, indexes_to_delete)
    end

    # Se calcula el balance a partir del array de outputs no referenciados
    user_balance = 0.0
    foreach(output_info_elem -> user_balance += output_info_elem[output_str].value, user_outputs_info_array)

    return user_balance, user_outputs_info_array
end

# Busca el correspondiente bloque e imprime su informacion. FAIl si no lo encuentra
function FindBlock(chain::Chain, block_id::String)

    for block_iter in chain.blocks_array
        block_str = BlockModule.ToString(block_iter)
        if cmp(HashString(block_str), block_id) == 0
            return block_str
        end
    end

    # El block_id no fue encontrado
    return false
end

# Busca la correspondiente transaction e imprime su informacion. FAIl si no la encuentra
function FindTx(chain::Chain, tx_id::String)

    for block_iter in chain.blocks_array
        # TODO descomentar cuando FindTx este definida en BlockModule
        # result = BlockModule.FindTx(block_iter, tx_id)
        if result != false
            return result
        end
    end

    # El tx_id no fue encontrado
    return false
end

# Devuelve la blockchain convertida a string para salvarla
function Save(chain::Chain)
    return ToString(chain)
end

# Carca en chain la blockchain que se lee desde el archivo
function Load(chain::Chain, file::IOStream)

    loaded_blockchain = Chain()

    while !eof(file)
        block = BlockModule.LoadBlock(file)
        if block == false
            return fail_str
        end
        AddBlock(loaded_blockchain, block)
    end

    chain.blocks_array = loaded_blockchain.blocks_array
    chain.mempool = loaded_blockchain.mempool

    return ok_str
end

# Busca todos los inputs asociados al usuario en la blockchain y en la mempool
function FindInputsByAddr(chain::Chain, addr::String)

    found_inputs = Array{BlockModule.TransactionModule.InputModule.Input}(undef, 0)

    # Se busca primero en la blockchain
    for block_iter in chain.blocks_array
        append!(found_inputs, BlockModule.FindInputsByAddr(block_iter, addr))
    end

    # Se completa la busqueda buscando en la mempool
    append!(found_inputs, BlockModule.FindInputsByAddr(chain.mempool, addr))

    return found_inputs
end

# Busca todos los ouputs info asociados al usuario en la blockchain y en la mempool
function FindOutputsInfoByAddr(chain::Chain, addr::String)
    outputs_info = Array{Dict{String,Any}}(undef, 0)

    # Se busca primero en la blockchain
    for block_element in chain.blocks_array
        append!(outputs_info, BlockModule.FindOutputsInfoByAddr(block_element, addr))
    end

    # Se completa la busqueda buscando en la mempool
    append!(outputs_info, BlockModule.FindOutputsInfoByAddr(chain.mempool, addr))

    return outputs_info
end

# Agregar nuevo block a la Blockchain ---------------------------------------------------------
function AddBlock(chain::Chain, block::BlockModule.Block)
    push!(chain.blocks_array, block)
    return nothing
end

# Convertir blockchain a string en el formato correspondiente ---------------------------------
function ToString(chain::Chain)
    blocks_string::String = ""

    for block_iter in chain.blocks_array
        blocks_string = blocks_string * BlockModule.ToString(block_iter)
    end

    return blocks_string
end

end # BlockchainModule
