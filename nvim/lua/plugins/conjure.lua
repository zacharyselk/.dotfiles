-- https://github.com/Olical/conjure

vim.g["conjure#mapping#log_buf"] =                                        "lz"  -- Default
vim.g["conjure#eval#result_register"] =                                    "c"  -- Default
vim.g["onjure#eval#inline_results"] =                                     true  -- Default
vim.g["conjure#eval#inline#highlight"] =                             "Comment"  -- Default
vim.g["conjure#eval#inline#prefix"] =                                     "=>"  -- Default
vim.g["conjure#eval#comment_prefix"] =                                     nil  -- Default
--vim.g["conjure#eval#gsubs"] = ???
vim.g["conjure#mapping#prefix"] =                              "<LocalLeader>"  -- Default
vim.g["conjure#mapping#log_split"] =                                     ";ls"  -- Modified from: "ls"
vim.g["conjure#mapping#log_vsplit"] =                                    ";lv"  -- Modified from: "lv"
vim.g["conjure#mapping#log_tab"] =                                       ";lt"  -- Modified from: "lt"
vim.g["conjure#mapping#log_buf"] =                                       ";le"  -- Modified from: "le"
vim.g["conjure#mapping#log_toggle"] =                                    ";lg"  -- Modified from: "lg"
vim.g["conjure#mapping#log_reset_soft"] =                                ";lr"  -- Modified from: "lr"
vim.g["conjure#mapping#log_reset_hard"] =                                ";lR"  -- Modified from: "lR"
vim.g["conjure#mapping#log_jump_to_latest"] =                            ";ll"  -- Modified from: "ll"
vim.g["conjure#mapping#log_close_visible"] =                             ";lq"  -- Modified from: "lq"

vim.g["conjure#mapping#eval_current_form"] =                             ";ee"  -- Modified from: "ee"
vim.g["conjure#mapping#eval_comment_current_form"] =                    ";ece"  -- Modified from: "ece"
vim.g["conjure#mapping#eval_root_form"] =                                ";er"  -- Modified from: "er"
vim.g["conjure#mapping#eval_comment_root_form"] =                       ";ecr"  -- Modified from: "ecr"
vim.g["conjure#mapping#eval_word"] =                                     ";ew"  -- Modified from: "ew"
vim.g["conjure#mapping#eval_comment_word"] =                            ";ecw"  -- Modified from: "ecw"
vim.g["conjure#mapping#eval_replace_form"] =                             ";e!"  -- Modified from: "e!"
vim.g["conjure#mapping#eval_marked_form"] =                              ";em"  -- Modified from: "em"
vim.g["conjure#mapping#eval_comment_form"] =                            ";ecf"  -- Modified from: "ec"
vim.g["conjure#mapping#eval_file"] =                                     ";ef"  -- Modified from: "ef"
vim.g["conjure#mapping#eval_buf"] =                                      ";eb"  -- Modified from: "eb"
vim.g["conjure#mapping#eval_visual"] =                                    ";v"  -- Modified from: "E"
vim.g["conjure#mapping#eval_motion"] =                                    ";v"  -- Modified from: "E"
vim.g["conjure#mapping#def_word"] =                                      ";gd"  -- Modified from: "gd"
vim.g["conjure#mapping#doc_word"] =                                      ";gk"  -- Modified from: ["K"]

vim.g["conjure#completion#omnifunc"] =                       "ConjureOmnifunc"  -- Default
vim.g["conjure#completion#fallback"] =               "syntaxcomplete#Complete"  -- Default
vim.g["conjure#highlight#enabled"] =                                     false  -- Default
vim.g["conjure#highlight#group"] =                                 "IncSearch"  -- Default
vim.g["conjure#highlight#timeout"] =                                       500  -- Default
vim.g["conjure#log#hud#width"] =                                          0.42  -- Default
vim.g["conjure#log#hud#enabled"] =                                        true  -- Default
vim.g["conjure#log#hud#passive_close_delay"] =                             250  -- Modified from: 0
vim.g["conjure#log#hud#minimum_lifetime_ms"] =                             250  -- Modified from: 20
vim.g["conjure#log#hud#overlap_padding"] =                                 0.1  -- Default
vim.g["conjure#log#hud#anchor"] =                                         "NE"  -- Default
vim.g["conjure#log#hud#border"] =                                     "single"  -- Default
vim.g["conjure#log#hud#ignore_low_priority"] =                           false  -- Default
vim.g["conjure#log#botright"] =                                          false  -- Default
vim.g["conjure#log#break_length"] =                                         80  -- Default
vim.g["onjure#log#trim#at"] =                                            10000  -- Default
vim.g["conjure#log#trim#to"] =                                            7000  -- Default
vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] =              100  -- Default
vim.g["conjure#log#wrap"] =                                              false  -- Default
vim.g["conjure#log#fold#enabled"] =                                      false  -- Default
vim.g["conjure#log#fold#lines"] =                                           10  -- Default
vim.g["conjure#log#fold#marker#start"] =                               "~~~%{"  -- Default
vim.g["conjure#log#fold#marker#end"] =                                 "}%~~~"  -- Default
vim.g["conjure#log#jump_to_latest#enabled"] =                            false  -- Default
vim.g["conjure#log#jump_to_latest#cursor_scroll_position"] =             "top"  -- Default
vim.g["conjure#extract#context_header_lines"] =                             24  -- Default
--vim.g["conjure#extract#form_pairs"] =     [["(" ")"] ["{" "}"] ["[" "]" true]]  -- Default
vim.g["conjure#extract#tree_sitter#enabled"] =                           false  -- Default
vim.g["conjure#preview#sample_limit"] =                                    0.3  -- Default
vim.g["conjure#relative_file_root"] =                                      nil  -- Default
vim.g["conjure#path_subs"] =                                               nil  -- Default
vim.g["conjure#client_on_load"] =                                         true  -- Default
vim.g["conjure#debug"] =                                                 false  -- Default
vim.b["conjure#context"] =                                                 nil  -- Default

local status_ok, conjure = pcall(require, "conjure")
if not status_ok then
  print("Error: Conjure did not load!")
	return
end
