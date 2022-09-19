-- Utility Module ---------------------------------------------------------------------------------
function parameter_types(...)
  local args = table.pack(...);
  for i=1, args.n, 2 do
    local var = args[i];
    local var_type = args[i+1];
    local var_types = {};
    for t in string.gmatch(var_type, "([^|]+)") do
      table.insert(var_types, t);
    end

    if (#var_types > 1) then
      for i,t in ipairs(var_types) do
        if (type(var) == t) then
          return;
        end
      end
      assert(false, string.format("Expected %s but recieved %s", var_type, var));
    else
      assert(type(var) == var_type, string.format("Expected %s but recieved %s", var_type, var));
    end
  end
end

function get_timestamp()
  local date = os.date("%x");
  local time = os.date("%X");
  date = string.gsub(date, '/', '-');
  time = string.gsub(time, ':', '-');
  return date..'_'..time;
end

function last_element(array)
  if (type(array) == "string") then
    return array:sub(-1, -1)
  elseif (type(array) == "table") then
    return array[#array];
  end
  return nil;
end

function run_command(command)
  parameter_types(command, "string");

  local output_file = io.popen(command);
  local output = output_file:read("*all");
  if (last_element(output) == '\n') then
    output = output:sub(1, -2);
  end
  output_file:close();
  return output;
end

function create_directory(path)
  parameter_types(path, "string");

  run_command(string.format("mkdir -p %s", path));
end
---------------------------------------------------------------------------------------------------
