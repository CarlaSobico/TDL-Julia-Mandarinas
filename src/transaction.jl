module TransactionModule

include("input.jl")
include("output.jl")
include("util.jl")

# Imports

import SHA
import .OutputModule
import .InputModule

# Structs

mutable struct Tx
    n_tx_in::Int64
    inputs_array::Array{InputModule.Input}

    n_tx_out::Int64
    outputs_array::Array{OutputModule.Output}

    # Default Constructor
    Tx(n_tx_in=0, inputs_array=Array{InputModule.Input}[], n_tx_out=0, outputs_array=Array{OutputModule.Output}[]
    ) = new(n_tx_in, inputs_array, n_tx_out, outputs_array)
end

# Functions/Methods

# Agregar nuevo input a la transaccion --------------------------------------------------------
function AddInput(tx::Tx, input::InputModule.Input)
    push!(tx.inputs_array, input)
    tx.n_tx_in += 1
end

# Agregar nuevo output a la transaccion -------------------------------------------------------
function AddOutput(tx::Tx, output::OutputModule.Output)
    push!(tx.outputs_array, output)
    tx.n_tx_out += 1
end

# Buscar inputs en la transaccion por addr. Devuelve un array de Inputs -----------------------
function FindInputsByAddr(tx::Tx, addr::String)
    found_inputs_indexes = findall(x -> InputModule.CompareAddr(x, addr), tx.inputs_array)
    return tx.inputs_array[found_inputs_indexes]
end

# Buscar outpoints en la transaccion por addr. Devuelve un array de Outpoints(dictionaries) ---
function FindOutpointsByAddr(tx::Tx, addr::String)

    # Se obtienen los inputs asociados al usuario addr
    found_inputs_indexes = findall(x -> InputModule.CompareAddr(x, addr), tx.inputs_array)

    # Se crea un vector de outpoints de los inputs encontrados
    outpoints_array = Array{Dict{String,Any}}(undef, 0)
    for i in found_inputs_indexes
        outpoint = Dict{String,Any}(
            tx_id_str => tx.inputs_array[i].tx_id, idx_str => tx.inputs_array[i].idx
        )
        push!(outpoints_array, outpoint)
    end

    return outpoints_array
end

# Buscar output en la transaccion por addr ----------------------------------------------------
function FindOutputsByAddr(tx::Tx, addr::String)
    found_outputs_indexes = findall(x -> OutputModule.CompareAddr(x, addr), tx.outputs_array)
    return tx.outputs_array[found_outputs_indexes]
end

# Convertir transaccion a string en el formato correspondiente --------------------------------
function ToString(tx::Tx)

    inputs_string::String = ""
    outputs_string::String = ""

    for input_iter in tx.inputs_array
        inputs_string = inputs_string * InputModule.ToString(input_iter)
    end

    for output_iter in tx.outputs_array
        outputs_string = outputs_string * OutputModule.ToString(output_iter)
    end
    return string(tx.n_tx_in, '\n', inputs_string, tx.n_tx_out, '\n', outputs_string)
end

end # TransactionModule