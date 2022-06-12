module ChainModule

    # Includes    
    include("block.jl")

    # Imports
    
    import .BlockModule

    # Structs

    mutable struct Chain
        blocks_array::Array{BlockModule.Block}

        Chain(blocks_array = Array{BlockModule.Block}[]) = new(blocks_array)
    end

    # Functions/Methods

    # Iniciar BlockChain. Agregaga bloque genesis
    function Init(chain::Chain, user::String, value::Int, bits::Int)
        
        empty!(chain.blocks_array)
        
        genesis_block = BlockModule.Block() # TODO: Obtener Genesis Block
        AddBlock(chain, genesis_block)
    end

    # Transfiere coins del usuario source a los destinatarios (si es posible)
    function Transfer(chain::Chain, user_source::String, destinations::Array{Dict{String, Int}})
        
        # Se calcula la cantidad de coins a transferir entre todos los destinatarios
        for destinations_iter in destinations 
            sum_coins += get(destinations_iter, value_str, 0)
        end

        # Se chequea que el user cuente con coins suficientes
        [balance, outputs_info] = Balance(chain, user_source)

        if sum_coins > balance
            return false
        else
            # TODO Crear transaccion a partir de outputs_info
        end
    end

    # Agrega lo guardado en la mempool hasta el momento en la Blockchain minando el bloque con bits de dificultad
    function Mine(chain::Chain, mempool::BlockModule.Block, bits::Int)

        # TODO: Minar bloque y dejarlo listo para agregar a la Blockchain
        AddBlock(chain, mempool)
    end

    # Devuelve la cantidad de coins del usuario. FAIL si no encuentra al usuario y la info de los outputs de donde extraerlos
    function Balance(chain::Chain, user_source::String)
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

            result = BlockModule.FindTx(block_iter, tx_id)
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

    # Agregar nuevo block a la Blockchain ---------------------------------------------------------
    function AddBlock(chain::Chain, block::BlockModule.Block)
        push!(chain.blocks_array, block)
        return nothing
    end

    # Convertir blockchain a string en el formato correspondiente ---------------------------------
    function ToString(chain::Chain)
        blocks_string::String = "";

        for block_iter in chain.blocks_array
            blocks_string = blocks_string * BlockModule.ToString(block_iter)
        end

        return blocks_string
    end

end # BlockchainModule