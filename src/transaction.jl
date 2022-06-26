module TransactionModule

include("input.jl")
include("output.jl")
include("util.jl")

# Imports

import SHA
import .OutputModule
import .InputModule

    mutable struct Tx
        n_tx_in::Int
        inputs_array::Array{InputModule.Input}

        n_tx_out::Int
        outputs_array::Array{OutputModule.Output}

    # Default Constructor
    Tx(n_tx_in=0, inputs_array=Array{InputModule.Input}[], n_tx_out=0, outputs_array=Array{OutputModule.Output}[]
    ) = new(n_tx_in, inputs_array, n_tx_out, outputs_array)
end

# Functions/Methods

# Transaccion genesis
function Genesis(value::Float64, addr::String)
    
    tx = Tx()

    AddInput(tx, InputModule.Genesis())
    AddOutput(tx, OutputModule.Genesis(value, addr))

    return tx
end

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

# Buscar output en la transaccion por addr y ademas devuelve el tx_id y el idx ----------------
function FindOutputsInfoByAddr(tx::Tx, addr::String)

    outputs_info = Array{Dict{String, Any}}(undef, 0)

    found_outputs_indexes = findall(x -> OutputModule.CompareAddr(x, addr), tx.outputs_array)
    tx_id = HashString(ToString(tx))

    for index in found_outputs_indexes

        output_info_element = Dict{String, Any}(
              tx_id_str => tx_id
            , idx_str => index
            , output_str => tx.outputs_array[index]
        )

        push!(outputs_info, output_info_element)
    end

    return outputs_info
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

# Crea una transaccion a partir de los destintarios y la info de los outputs disponibles para el user_source
function CreateTransaction(user_source::String, amount_of_coins::Float64, available_outputs_array::Array{Dict{String, Any}}, destinations_array::Array{Dict{String, Any}})

    tx = Tx()
    
    needed_coins = amount_of_coins

    # Se crean los inputs a partir de los available outputs de donde se pueden sacar coins
    for output_info in available_outputs_array

        input = InputModule.Input(output_info[tx_id_str], output_info[idx_str], user_source)
        AddInput(tx, input)

        output_coins = output_info[output_str].value
        needed_coins -= output_coins

        if needed_coins <= 0
            break
        end
    end

    # Se crean los outputs a partir de los destinations y del vuelto
    if needed_coins != 0
        output = OutputModule.Output(abs(needed_coins), user_source)
        AddOutput(tx, output)
    end

    for destinations_iter in destinations_array 
        output = OutputModule.Output(destinations_iter[value_str], destinations_iter[addr_str])
        AddOutput(tx, output)
    end

    return tx
end

# Lee una transaccion de un archivo
function LoadTx(file::IOStream)

    tx = Tx()

    n_tx_in = parse(Int, readline(file))
    for _ in 1:n_tx_in
        input = InputModule.LoadInput(file)
        AddInput(tx, input)
    end

    n_tx_out = parse(Int, readline(file))
    for _ in 1:n_tx_out
        output = OutputModule.LoadOutput(file)
        AddOutput(tx, output)
    end

    if n_tx_out != length(tx.outputs_array) || n_tx_in != length(tx.inputs_array)
        return false
    end
    
    return tx
end

end # TransactionModule