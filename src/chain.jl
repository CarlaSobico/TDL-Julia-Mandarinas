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
        
        # TODO: Add Genesis Block
    end

    # Transfiere coins del usuario source a los destinatarios (si es posible)
    function Transfer(chain::Chain, user_source::String, destinations::Array{Dict{String, Int}})
        
        # Se chequea que el user cuente con coins suficientes
    end

    # Agrega lo guardado en la mempool hasta el momento en la Blockchain minando el bloque con bits de dificultad
    function Mine(chain::Chain, mempool::BlockModule.Block, bits::Int)
    end


    # Devuelve la cantidad de coins del usuario. FAIL si no encuentra al usuario
    function Balance(chain::Chain, user_source::String)
    end

    # Busca el correspondiente bloque e imprime su informacion. FAIl si no lo encuentra
    function FindBlock(chain::Chain, block_id::String)
    end

    # Busca la correspondiente transaction e imprime su informacion. FAIl si no la encuentra
    function FindTx(chain::Chain, tx_id::String)
    end

    # Imprime lo realizado en la Blockchain hasta el momento en el formato correspondiente
    function Save(chain::Chain)
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