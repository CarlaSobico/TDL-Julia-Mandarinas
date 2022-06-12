module BlockModule

    # Includes    
    include("transaction.jl")

    # Imports
    
    import .TransactionModule

    # Structs
    mutable struct Block
        # Header
        prev_block::String;  # El hash del bloque completo que antecede al bloque actual en la Algochain.
	    txns_hash::String;  # El hash de todas las transacciones incluidas en el bloque.
	    bits::Int;  # Valor entero positivo que indica la dificultad con la que fue minada este bloque.
	    nonce::Int;  # Un valor entero no negativo que puede contener valores arbitrarios. El objetivo de este 
		    		 # campo es tener un espacio de prueba modificable para poder generar hashes sucesivos hasta 
			    	 # satisfacer la dificultad del minado.
        # Body
        txn_count::Int;
        txns::Array{TransactionModule.Tx};
        Block(prev_block = "default_prev_block"
            , txns_hash = "default_txns_hash"
            , bits = 0
            , nonce = 0
            , txn_count = 0
            , txns = Array{TransactionModule.Tx}[]
            ) = new(prev_block, txns_hash, bits, nonce, txn_count, txns)
    end

    function AddTx()

    end
    function ToString(block::Block)
        bits_string = string(block.bits)
        nonce_string = string(block.nonce)
        txn_count_string = string(block.txn_count)
        txns_string::String = ""
    
        for tx_iter in block.txns
            txns_string = txns_string * TransactionModule.ToString(tx_iter)
        end
    
        return string(block.prev_block, "\n", block.txns_hash, "\n", bits_string, "\n", nonce_string, "\n", txn_count_string, "\n", txns_string, "\n")
    
    end
	function ArrayTxToString()
        
    end
	function FindInputsByAddr()
        
    end
	function FindOutputsByAddr()
        
    end

end # module Input
