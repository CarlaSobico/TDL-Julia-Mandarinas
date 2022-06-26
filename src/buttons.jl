using Gtk
using Dates

# Create a window
text_info = "Blockchain GUI"
textlabel_info = GtkLabel(text_info)
set_gtk_property!(textlabel_info, :xalign, 0.5) # centers first line

# Create a button
excecute_button = GtkButton("Executon Button")

# Create the entry point
command_entry = GtkEntry()
set_gtk_property!(command_entry, :xalign, 0.01)
set_gtk_property!(command_entry, :text, "Insert command")

# Create the output text area
textbuffer_results = GtkTextBuffer() # access point for text
textview = GtkTextView(textbuffer_results) # buffer inside textview
scrolledwindow = GtkScrolledWindow(textview) # textview inside scrolledwindow
set_gtk_property!(scrolledwindow, :min_content_height, 200)
set_gtk_property!(textview, :wrap_mode, 2)
set_gtk_property!(textview, :left_margin, 5)

# Create grid
grid = GtkGrid()
set_gtk_property!(grid, :column_homogeneous, true)
grid[1:4,1] = textlabel_info
grid[1,2] = excecute_button
grid[2:4,2] = command_entry
grid[1:4,4] = scrolledwindow

# CREATE THE WINDOW AND ADD THE GRID
window = GtkWindow("Blockchain", 1000, 300)
set_gtk_property!(window, :resizable, true) 
push!(window, grid)
showall(window)

# RESPOND TO BUTTON CLICKS AND EVENTS
button_setfile_triggered = signal_connect(excecute_button, "clicked") do widget
    str = get_gtk_property(command_entry, :text, String)
    println(str)
end


# condition keeps window open, unless closed by user.
if !isinteractive()
    c = Condition()
    signal_connect(window, :destroy) do widget
        notify(c)
    end
    wait(c)
end