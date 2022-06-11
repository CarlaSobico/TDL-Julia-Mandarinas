module Transaction

    # =============================================================================================
    # Imports
    # =============================================================================================

    import(SHA)

    # =============================================================================================
    # Structs
    # =============================================================================================

    mutable struct Tx
        n_tx_in::Int64
        inputs_array::Array{Int64}      # TODO: Replace Int64 with Input

        n_tx_out::Int64
        outputs_array::Array{Int64}     # TODO: Replace Int64 with Output

        # Default Constructor
        Tx(    n_tx_in = 0
            , inputs_array = Array{Int64}[]
            , n_tx_out = 0
            , outputs_array = Array{Int64}[]) = new(n_tx_in, inputs_array, n_tx_out, outputs_array)
    end

    # =============================================================================================
    # Functions/Methods
    # =============================================================================================

    # Append new input to transaction -------------------------------------------------------------
    function AddInput(tx::Tx, input::Int64)
        append!(tx.inputs_array, input)
        tx.n_tx_in += 1
    end

    # Append new output to transaction ------------------------------------------------------------
    function AddOutput(tx::Tx, output::Int64)
        append!(tx.outputs_array, output)
        tx.n_tx_out += 1
    end

    # Look for input in the transaction. True is was found, False if not --------------------------
    function FindInput(tx::Tx, input::Int64)
        return !isempty(findall(x -> x == input, tx.inputs_array))
    end

    # Look for input in the transaction by addr ---------------------------------------------------
    function FindInput(tx::Tx, addr::String)
        return # TODO
    end

    # Look for output in the transaction. True is was found, False if not -------------------------
    function FindOutput(tx::Tx, output::Int64)
        return !isempty(findall(x -> x == output, tx.outputs_array))
    end

    # Look for output in the transaction by addr --------------------------------------------------
    function FindOutput(tx::Tx, addr::String)
        return # TODO
    end

    # Look for output in the transaction by addr --------------------------------------------------
    function ToString(tx::Tx)
        return string( tx.n_tx_in
                    , '\n'
                    ,  join(tx.inputs_array)
                    , '\n'
                    , tx.n_tx_out
                    , '\n'
                    , join(tx.outputs_array))
    end
    
end # module Transaction