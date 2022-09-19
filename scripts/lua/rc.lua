dofile("lua/file.lua");
dofile("lua/utility.lua");


-- RC Module --------------------------------------------------------------------------------------
local function backup_rc(envrionment_variables)
  parameter_types(envrionment_variables, "table");

  local default_rc = assert(envrionment_variables["DEFAULT_RC"], "Missing DEFAULT_RC");
  local command = string.format("cp %s %s", default_rc, default_rc..'_'..get_timestamp());
  run_command(command);
end

local function is_block_header(line)
  parameter_types(line, "string");

  if (string.len(line) == 80 and string.gmatch(line, "#### [a-zA-Z0-9%._%-%s]+ ####") ~= nil) then
    return true;
  else
    return false;
  end
end

local function is_block_footer(line)
  parameter_types(line, "string");

  if (line == string.rep("#", 80)) then
    return true;
  else
    return false;
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
    if (reading_block) then
      block[#block + 1] = line_number;
      if is_block_footer(line) then
        reading_block = false;
	blocks[#blocks + 1] = block;
	block = {};
      end
    elseif (is_block_header(line)) then
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
  for i,block in ipairs(blocks) do
    if (get_block_header_name(lines[block[1]]) == "Environement-Variables") then
      envrionment_variables_block_found = true;
    end
  end

  if (not envrionment_variables_block_found) then
    local lines_len = #lines;
    lines[lines_len + 1] = "";
    lines[lines_len + 2] = "#### Environement-Variables ####################################################";
    lines[lines_len + 3] = "################################################################################";
    local new_block = {lines_len + 2, lines_len + 3};
    blocks[#blocks + 1] = new_block;
  end

  for i,v in ipairs(get_managed_blocks(default_rc)) do 
    if (get_block_header_name(lines[v[1]]) == "Environement-Variables") then
      local export_exists = false;
      for j, block_line_number in pairs(v) do
        if (lines[block_line_number] == export_variable) then
          export_exists = true;
	  break;
        end
      end
      if (not export_exists) then
        table.insert(lines, v[#v], export_variable);
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
---------------------------------------------------------------------------------------------------
