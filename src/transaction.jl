module Transaction

    # Includes

    # Structs
    mutable struct Tx
        n_tx_in::Int64
        inputs_array::Array{Int64}      # TODO: Replace Int64 with Input

        n_tx_out::Int64
        outputs_array::Array{Int64}     # TODO: Replace Int64 with Output
    end
    export Tx

    # Default Constructor
    Tx(;   n_tx_in = 0
         , inputs_array = Array{Int64}[]
         , n_tx_out = 0
         , outputs_array =  Array{Int64}[]) = new(n_tx_in, inputs_array, n_tx_out, outputs_array)

    # Functions/Methods
    # function test(tx_in::Tx)
    #     println("hola")
    #     println(tx_in.n_tx_in)
    # end
    # export test

end # module Transaction