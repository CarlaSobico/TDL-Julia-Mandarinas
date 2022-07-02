"""
@brief

@authors  Perczyk Francisco
          Quattrone Martin
          Sobico Carla
"""

include("chain.jl")
include("util.jl")
include("gui.jl")
# Using
import .ChainModule
# Functions

function Init(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    # result = ChainModule.Init(chain,HashString(string(inputs_string[2])), parse(Float64 , inputs_string[3]), parse(Int, inputs_string[4]))
    result = ChainModule.Init(chain,(string(inputs_string[2])), parse(Float64 , inputs_string[3]), parse(Int, inputs_string[4]))
    
    return result
end

function Transfer(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    # user_source = HashString(string(inputs_string[2]))
    user_source = (string(inputs_string[2]))
    
    destinations_array = Array{Dict{String,Any}}(undef, 0)

    i = 3
    while i < length(inputs_string)

        # addr = HashString(string(inputs_string[i]))
        addr = (string(inputs_string[i]))

        i += 1
        value = parse(Float64, inputs_string[i])
        i += 1

        push!(destinations_array, Dict(addr_str => addr, value_str => value))
    end

    result = ChainModule.Transfer(chain, user_source, destinations_array)

    return result
end

function Mine(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    result = ChainModule.MineAndAddMempool(chain, parse(Int, inputs_string[2]))

    return result
end

function Balance(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    # user_addr = HashString(string(inputs_string[2]))
    user_addr = (string(inputs_string[2]))

    result, outputs_info_array = ChainModule.GetBalance(chain, user_addr)

    return result
end

function Txn(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    return "Txn"
end

function Block(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})
    return "Block"
end

function Save(chain::ChainModule.Chain, inputs_string::Array{SubString{String}})

    blockchain_string = ChainModule.Save(chain)

    file_name = string(default_path, inputs_string[2])

    # Se chequea si tiene extension el nombre
    split = splitext(file_name)
    if split[2] == ""
        file_name = string(file_name, ".txt")
    end

    # Se escribe en el archivo
    file = open(file_name, "w")
    write(file, blockchain_string)
    close(file)

    return ok_str

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

    return result

end

function execute_command_without_gui(blockchain, commands_dict, line_str::String)

    input_strings = split(line_str)
    command_str = input_strings[1]
    command_function = get(commands_dict, command_str, false)

    result_str = string(command_function(blockchain, input_strings))
end

function main()

    # Se crea la blockchain
    blockchain = ChainModule.Chain()

    # Diccionario de comandos
    commands_dict = Dict(init_command => Init, transfer_command => Transfer, mine_command => Mine, balance_command => Balance, txn_command => Txn, block_command => Block, save_command => Save, load_command => Load)
    
    run_with_gui = true

    if (run_with_gui == false)
        selected_filepath = "/Users/franciscoperczyk/Desktop/Facultad/tdl/TDL-Julia-Mandarinas/src/input/commands_1.txt"
        
        open(selected_filepath, "r") do io

            timer = TimerOutput()

            @timeit timer "Total" begin
                str = read(io, String)
                lines_array = split(str, '\n')
                for line_iter in lines_array 
                    execute_command_without_gui(blockchain, commands_dict, string(line_iter))
                end
            end
            disable_timer!(timer)
            show(timer)
        end
        open(selected_filepath, "r") do io

            timer = TimerOutput()

            @timeit timer "Total" begin
                str = read(io, String)
                lines_array = split(str, '\n')
                for line_iter in lines_array 
                    execute_command_without_gui(blockchain, commands_dict, string(line_iter))
                end
            end
            disable_timer!(timer)
            show(timer)
        end
    
    else
        create_gui(commands_dict, blockchain)
    end

end


main()
