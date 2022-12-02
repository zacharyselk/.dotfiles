dofile("lua/file.lua");
dofile("lua/utility.lua");


-- RC Module --------------------------------------------------------------------------------------
-- "Run Commands" of .bachrc, .zshrc, etc.

local function backup_rc(envrionment_variables)
  parameter_types(envrionment_variables, "table");

  local default_rc = assert(envrionment_variables["DEFAULT_RC"], "Missing DEFAULT_RC");
  local command = string.format("cp %s %s", default_rc, default_rc..'_'..get_timestamp());
  run_command(command);
end

local function maybe_block_header(line)
  parameter_types(line, "string");

  local match = string.gmatch(line, "#### START ([a-zA-Z0-9%._%-%s]+) ####*");
  if (string.len(line) == 80 and string.gmatch(line, "#### START ([a-zA-Z0-9%._%-%s]+) ####*") ~= nil) then
    return { has_value=true, value=match() };
  else
    return { has_value=false };
  end
end

local function maybe_block_footer(line)
  parameter_types(line, "string");

  local match = string.gmatch(line, "#### END   ([a-zA-Z0-9%._%-%s]+) ####*");
  if (string.len(line) == 80 and match ~= nil) then
    return { has_value=true, value=match() };
  else
    return { has_value=false };
  end
end

local function get_block_header_name(line)
  parameter_types(line, "string");

  line = line:sub(6, -1);
  return string.gsub(line, " #+", "");
end

local function get_managed_blocks(filename)
  parameter_types(filename, "string");

  local blocks = {}
  local block = {}
  local lines = read_file_lines(filename);
  local reading_block = false;
  for line_number,line in ipairs(lines) do
    local maybe_header = maybe_block_header(line);
    local maybe_footer = maybe_block_footer(line);
    if (reading_block) then
      block[#block + 1] = line_number;
      if maybe_footer["has_value"] then
        reading_block = false;
	      blocks[maybe_footer["value"]] = block;
	      block = {};
      end
    elseif (maybe_header["has_value"]) then
      reading_block = true;
      block[#block + 1] = line_number;
    end
  end

  return blocks
end

function add_rc_environment_variable(variable, value, envrionment_variables)
  parameter_types(variable, "string", value, "string", envrionment_variables, "table");

  local default_rc = assert(envrionment_variables["DEFAULT_RC"], "Missing DEFAULT_RC");
  backup_rc(envrionment_variables);

  local export_variable = string.format('export %s="%s"', variable, value);
  print(default_rc);
  local lines = read_file_lines(default_rc);
  local blocks = get_managed_blocks(default_rc);
  local envrionment_variables_block_found = false;
  for name, block in pairs(blocks) do
    if (name == "Environment-Variables") then
      envrionment_variables_block_found = true;
    end
  end

  if (not envrionment_variables_block_found) then
    local lines_len = #lines;
    lines[lines_len + 1] = "";
    lines[lines_len + 2] = "#### START Environment-Variables ###############################################";
    lines[lines_len + 3] = "#### END   Environment-Variables ###############################################";
    local new_block = {lines_len + 2, lines_len + 3};
    blocks[#blocks + 1] = new_block;
  end

  for name, block in pairs(get_managed_blocks(default_rc)) do 
    if (name == "Environment-Variables") then
      local export_exists = false;
      for j, block_line_number in pairs(block) do
        if (lines[block_line_number] == export_variable) then
          export_exists = true;
	  break;
        end
      end
      if (not export_exists) then
        table.insert(lines, block[#block], export_variable);
      end
    end
  end
  write_file(default_rc, table.concat(lines, '\n'));
end

function add_rc_alias(alias, value, envrionment_variables)
  parameter_types(alias, "string", value, "string", envrionment_variables, "table");

  local default_rc = assert(envrionment_variables["DEFAULT_RC"], "Missing DEFAULT_RC");
  backup_rc(envrionment_variables);

  local export_variable = string.format('alias %s="%s"', alias, value);
  print(default_rc);
  local lines = read_file_lines(default_rc);
  local blocks = get_managed_blocks(default_rc);
  local alias_block_found = false;
  for name, block in pairs(blocks) do
    if (name == "Aliases") then
      alias_block_found = true;
    end
  end

  if (not alias_block_found) then
    local lines_len = #lines;
    lines[lines_len + 1] = "";
    lines[lines_len + 2] = "#### START Aliases #############################################################";
    lines[lines_len + 3] = "#### END   Aliases #############################################################";
    local new_block = {lines_len + 2, lines_len + 3};
    blocks["Aliases"] = new_block;
  end

  for name, block in pairs(blocks) do 
    if (name == "Aliases") then
      local export_exists = false;
      for j, block_line_number in pairs(block) do
        if (lines[block_line_number] == export_variable) then
          export_exists = true;
	  break;
        end
      end
      if (not export_exists) then
        table.insert(lines, block[#block], export_variable);
      end
    end
  end
  write_file(default_rc, table.concat(lines, '\n'));
end

function append_to_path(path, envrionment_variables)
  parameter_types(path, "string", envrionment_variables, "table");

  add_rc_environment_variable("PATH", string.format("$PATH:%s", path), envrionment_variables);
end

function prepend_to_path(path, envrionment_variables)
  parameter_types(path, "string", envrionment_variables, "table");

  add_rc_environment_variable("PATH", string.format("%s:$PATH", path), envrionment_variables);
end

local function get_rc_environment_variables()
  return {
    {"PATH", "$PATH:$HOME/bin"},
    {"PATH", "$PATH:$HOME/.bin"},
  };
end

local function get_rc_aliases()
  return {
    {"ls", "exa --icons"},
    {"diff", "kitty +kitten diff"},
    {"icat", "kitty +kitten icat"},
    {"ssh", "kitty +kitten ssh"},
    {"rg", "kitty +kitten hyperlinked_grep"},
  };
end

local function add_rc_environment_variables(envrionment_variables)
  parameter_types(envrionment_variables, "table");

  for i, value in ipairs(get_rc_environment_variables()) do
    add_rc_environment_variable(value[1], value[2], envrionment_variables);
  end
end

local function add_rc_aliases(envrionment_variables)
  parameter_types(envrionment_variables, "table");

  for i, value in ipairs(get_rc_aliases()) do
    add_rc_alias(value[1], value[2], envrionment_variables);
  end
end

function add_rc_defaults(envrionment_variables)
  parameter_types(envrionment_variables, "table");

  add_rc_environment_variables(envrionment_variables);
  add_rc_aliases(envrionment_variables);
end
---------------------------------------------------------------------------------------------------
