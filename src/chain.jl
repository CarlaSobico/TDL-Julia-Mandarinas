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

        Chain(   blocks_array = Array{BlockModule.Block}[]
               , mempool = BlockModule.Block()) = new(blocks_array, mempool)
    end

    # Functions/Methods

    # Iniciar BlockChain. Agregaga bloque genesis
    function Init(chain::Chain, user::String, value::Int, bits::Int)
        
        # Se borra la actual Blockchain y la mempool
        empty!(chain.blocks_array)
        chain.mempool = BlockModule.Block()

        # TODO: Obtener Genesis Block
        genesis_block = BlockModule.Block()
        AddBlock(chain, genesis_block)
    end

    # Transfiere coins del usuario source a los destinatarios (si es posible)
    function Transfer(chain::Chain, user_source::String, destinations::Array{Dict{String, Any}})
        
        # Se calcula la cantidad de coins a transferir entre todos los destinatarios
        sum_coins::Float64 = 0.0
        for destinations_iter in destinations 
            sum_coins += get(destinations_iter, value_str, 0)
        end

        # Se chequea que el user cuente con coins suficientes
        balance, outputs_info = GetBalance(chain, user_source)

        if sum_coins > balance
            return false
        else
            # TODO Crear transaccion a partir de outputs_info y agregarla a la mempool
            return true
        end
    end

    # Agrega lo guardado en la mempool hasta el momento en la Blockchain minando el bloque con bits de dificultad
    function MineAndAddMempool(chain::Chain, bits::Int)

        # Solo se agrega si la mempool tiene alguna transaccion
        if chain.mempool.txn_count > 0

            # TODO: Lamar a Mine function de BlockModule para que mine la mepool
            #BlockModule.Mine(chain.mempool, bits)
            AddBlock(chain, chain.mempool)

            # Se reinicia la mepool
            chain.mempool = BlockModule.Block()
        end
    end

    # Devuelve la cantidad de coins del usuario. false si no encuentra al usuario y la info de los outputs de donde extraerlos
    function GetBalance(chain::Chain, user_source::String)
        return 0, 1
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