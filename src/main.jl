"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

include("chain.jl")
include("util.jl")

# Using
import .ChainModule

# Functions

function Init(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    println("Init")
end

function Transfer(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    user_source = HashString( string(inputs_string[2]))
    destinations_array = Array{Dict{String, Any}}(undef, 0)

    i = 3
    while i < length(inputs_string)
        
        addr = HashString(string(inputs_string[i]))
        i += 1
        value = parse(Float64, inputs_string[i])
        i += 1

        push!(destinations_array, Dict(addr_str => addr, value_str => value))
    end

    result = ChainModule.Transfer(chain, user_source, destinations_array)

    println(result)
end

function Mine(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    ChainModule.MineAndAddMempool(chain, 2)

end

function Balance(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    user_addr = HashString(string(inputs_string[2]))

    result, outputs_info_array = ChainModule.GetBalance(chain, user_addr)

    println(result)
end

function Txn(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    println("Txn")
end

function Block(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    println("Block")
end

function Save(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    
    blockchain_string = ChainModule.Save(chain)

    file_name = string(default_path, inputs_string[2])

    # Se chequea si tiene extension el nombre
    split = splitext(file_name)
    if split[2] == ""
        file_name = string(file_name, ".txt")
    end

    # se escribe en el archivo
    file = open(file_name, "w")
    write(file, blockchain_string)
    close(file)

    println(ok_str)
    
end

function Load(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    file_name = string(default_path, inputs_string[2])

    # Se chequea si tiene extension el nombre
    split = splitext(file_name)
    if split[2] == ""
        file_name = string(file_name, ".txt")
    end

    if isfile(file_name)
        
        file = open(file_name, "r")
        result = ChainModule.Load(chain, file)
    else
        result = fail_str
    end

    println(result)

end

function main()

    println("Inicio, ingrese un comando...")   

    # Se crea la blockchain
    blockchain = ChainModule.Chain()

    # Diccionario de comandos
    commands_dict = Dict( init_command => Init
                        , transfer_command => Transfer
                        , mine_command => Mine
                        , balance_command => Balance
                        , txn_command => Txn
                        , block_command => Block
                        , save_command => Save
                        , load_command => Load)

    # Bloque genesis trucho - Eliminar cuando comando mine este creado
    genesis_block = ChainModule.BlockModule.Block()
    output = ChainModule.BlockModule.TransactionModule.OutputModule.Output(1000, HashString("banco"))
    input = ChainModule.BlockModule.TransactionModule.InputModule.Input()
    tx = ChainModule.BlockModule.TransactionModule.Tx()
    ChainModule.BlockModule.TransactionModule.AddInput(tx, input)
    ChainModule.BlockModule.TransactionModule.AddOutput(tx, output)
    ChainModule.BlockModule.AddTx(genesis_block, tx)
    ChainModule.AddBlock(blockchain, genesis_block)

    while true

        # Leer de stdin
        input_strings = split(readline())

        command_str = input_strings[1]
        command_function = get(commands_dict, command_str, false)

        if command_function == false
            println("El comando [ ", command_str, " ] no es valido.") 
        else
            command_function(blockchain, input_strings)
        end
    end
    
    println("Fin")


   

    # # Bloque genesis
    # genesis_block = ChainModule.BlockModule.Block()
    # output = ChainModule.BlockModule.TransactionModule.OutputModule.Output(1000, "Banco")
    # input = ChainModule.BlockModule.TransactionModule.InputModule.Input()
    # tx = ChainModule.BlockModule.TransactionModule.Tx()
    # ChainModule.BlockModule.TransactionModule.AddInput(tx, input)
    # ChainModule.BlockModule.TransactionModule.AddOutput(tx, output)
    # ChainModule.BlockModule.AddTx(genesis_block, tx)
    # ChainModule.AddBlock(blockchain, genesis_block)

    # # Destinations
    # destinations = Array{Dict{String, Any}}(undef, 0)
    # push!(destinations, Dict(addr_str => "Fran", value_str => 20.0))
    # push!(destinations, Dict(addr_str => "Carla", value_str => 55.0))
    # push!(destinations, Dict(addr_str => "Quattro", value_str => 200.0))

    # # Transfer
    # ChainModule.Transfer(blockchain, "Banco", destinations)

    # for dst_iter in destinations 

    #     balance, outputs_info = ChainModule.GetBalance(blockchain, dst_iter[addr_str])

    #     println("Balance de ", dst_iter[addr_str], " es " , balance)
    # end

    # destinations = Array{Dict{String, Any}}(undef, 0)
    # push!(destinations, Dict(addr_str => "Lola", value_str => 12.0))
    # push!(destinations, Dict(addr_str => "Fran", value_str => 65.0))

    # ChainModule.MineAndAddMempool(blockchain, 2)

    # ChainModule.Transfer(blockchain, "Quattro", destinations)

    # for dst_iter in destinations 

    #     balance, outputs_info = ChainModule.GetBalance(blockchain, dst_iter[addr_str])

    #     println("Balance de ", dst_iter[addr_str], " es " , balance)
    # end
    # balance, outputs_info = ChainModule.GetBalance(blockchain, "Quattro")

    #     println("Balance de ", "Quattro", " es " , balance)

    # println(ChainModule.Save(blockchain))
end


main()
