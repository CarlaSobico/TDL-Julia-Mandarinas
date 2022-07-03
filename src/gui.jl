using Gtk
using Dates

using  TimerOutputs

function create_gui(commands_dict, blockchain)

    # Create a window
    text_info = "Blockchain GUI"
    textlabel_info = GtkLabel(text_info)
    set_gtk_property!(textlabel_info, :xalign, 0.5) # centers first line

    # Create am execution button
    execute_button = GtkButton("Execute Button")

    # Create am execution button
    select_button = GtkButton("Select File")

    # Create the entry point
    command_entry = GtkEntry()
    set_gtk_property!(command_entry, :xalign, 0.01)

    # Create the output text area
    textbuffer_results = GtkTextBuffer() # access point for text
    textview = GtkTextView(buffer = textbuffer_results) # buffer inside textview
    scrolledwindow = GtkScrolledWindow(textview) # textview inside scrolledwindow
    set_gtk_property!(textbuffer_results, :text, "")
    set_gtk_property!(scrolledwindow, :min_content_height, 200)
    set_gtk_property!(textview, :wrap_mode, 2)
    set_gtk_property!(textview, :left_margin, 5)
    

    # Create dropdown menu
    command_options = GtkComboBoxText()
    choices = ["init", "mine", "transfer", "balance", "block", "txn", "save", "load"]
    for choice in choices
        push!(command_options, choice)
    end
    # Lets set the active element to be "two"
    set_gtk_property!(command_options, :active, 0)


    # Create grid
    grid = GtkGrid()
    set_gtk_property!(grid, :column_homogeneous, true)
    grid[1:4, 1] = textlabel_info
    grid[1, 2] = command_options
    grid[2:3, 2] = command_entry
    grid[4, 2] = execute_button
    grid[1, 3] = select_button

    grid[1:4,4] = scrolledwindow


    # CREATE THE WINDOW AND ADD THE GRID
    window = GtkWindow("Blockchain", 1000, 300)
    set_gtk_property!(window, :resizable, true) 
    push!(window, grid)
    showall(window)

    # RESPOND TO BUTTON CLICKS AND EVENTS
    button_setfile_triggered = signal_connect(execute_button, "clicked") do widget
        parameter_str = get_gtk_property(command_entry, :text, String)
        set_gtk_property!(command_entry, :text, "")

        command_str = Gtk.bytestring(GAccessor.active_text(command_options))
        final_command_str = command_str * " " * parameter_str

        execute_command(blockchain, commands_dict, textbuffer_results, final_command_str)
    end
    
    change_dropdown_menu = signal_connect(command_options, "changed") do widgets
        set_gtk_property!(command_entry, :text, "")
    end

    select_file_menu = signal_connect(select_button, "clicked") do widget
        selected_filepath = open_dialog("SELECT FILE...")

        try
            open(selected_filepath, "r") do io

                timer = TimerOutput()

                @timeit timer "Total" begin
                    str = read(io, String)
                    lines_array = split(str, '\n')
                    for line_iter in lines_array 
                        execute_command(blockchain, commands_dict, textbuffer_results, string(line_iter))
                    end
                end
                disable_timer!(timer)
                show(timer)
        end
        catch
            return "Could not read the file contents."
        end
    end
    
    # condition keeps window open, unless closed by user.
    if !isinteractive()
        c = Condition()
        signal_connect(window, :destroy) do widget
            notify(c)
        end
        wait(c)
    end

end

function execute_command(blockchain, commands_dict, textbuffer_results, line_str::String)

    input_strings = split(line_str)
    command_str = input_strings[1]
    command_function = get(commands_dict, command_str, false)

    result_str = string(command_function(blockchain, input_strings))
    set_gtk_property!(textbuffer_results, :text, get_gtk_property(textbuffer_results, :text, String) * "\n" * "Comando: " * line_str)
    set_gtk_property!(textbuffer_results, :text, get_gtk_property(textbuffer_results, :text, String) * "\n" * "Resultado: " * result_str)

end